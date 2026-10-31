--- @class UIVictoryPveLayout : UIVictoryLayout
UIVictoryPveLayout = Class(UIVictoryPveLayout, UIVictoryLayout)

function UIVictoryPveLayout:InitLayoutConfig()
    --- @type UIVictoryPveLayoutConfig
    self.layoutConfig = UIBaseConfig(self.anchor)
    self.animIndex = 0
end

function UIVictoryPveLayout:InitCancelAutoNextBattle()
    self.layoutConfig.autoBattleView.onClick:RemoveAllListeners()
    self.layoutConfig.autoBattleView.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBgAutoBattle()
    end)
end

function UIVictoryPveLayout:SetUpLayout()
    UIVictoryLayout.SetUpLayout(self)
    self.config.rewardAnchor.anchoredPosition3D = U_Vector3(0, -40, 0)
end

--- @param data {gameMode : GameMode, isWin : boolean, result, clientLogDetail}
function UIVictoryPveLayout:ShowData(data)
    if zg.playerData ~= nil and zg.playerData:HasReward() then
        self.view:SetReward(zg.playerData.rewardList)
    end
    if not data.isSkip and data.gameMode == GameMode.TOWER then
        self:InitCancelAutoNextBattle()
        self.config.autoBattleView.gameObject:SetActive(PlayerSettingData.isAutoNextBattle)
        if PlayerSettingData.isAutoNextBattle and self.view.model.isWin == true then
            self:DoCountdownAutoNext()
        end
    end
end

function UIVictoryPveLayout:OnFinishAnimation()
    UIVictoryLayout.OnFinishAnimation(self)
    self.view:CheckAndInitTutorial()
end

function UIVictoryPveLayout:DoCountdownAutoNext()
    self.coroutineWaitNextBattle = Coroutine.start(function()
        ---@type number
        local numberOfSecs = 5
        while (numberOfSecs > 0) do
            self.layoutConfig.textAutoEnd.text = string.format("%s: %s",
                    LanguageUtils.LocalizeCommon("auto_next_battle_in"), numberOfSecs)
            coroutine.waitforseconds(1)
            numberOfSecs = numberOfSecs - 1
        end
        if (PlayerSettingData.isAutoNextBattle) then
            self:ChallengeNextStage()
        end
    end)

    self.coroutineUpdateLoadingImage = Coroutine.start(function()
        while true do
            self:UpdateImageAnim()
            coroutine.waitforseconds(0.1)
        end
    end)
end

function UIVictoryPveLayout:ChallengeNextStage()
    ---@type TowerInBound
    local towerInBound = zg.playerData:GetMethod(PlayerDataMethod.TOWER)
    ---@type TowerData
    local towerConfig = ResourceMgr.GetTowerConfig()
    ---@type number
    local selectedLevel = towerInBound.selectedLevel
    local isValidLevel, _ = towerConfig:IsValidLevel(towerInBound.selectedFloorNum)
    local canBattle = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(
            ResourceType.Money, MoneyType.TOWER_STAMINA, 1)) and isValidLevel
    if canBattle and selectedLevel <= towerConfig.maxFloor then
        local gameMode = GameMode.TOWER
        local rewardList = towerConfig:GetReward(towerInBound.levelCurrent)
        --- @return DefenderTeamData
        local defenderTeamData = towerConfig:GetLevelConfig(selectedLevel)
        local showNextBattle = function(battleLog)
            ---@type DefenderTeamData
            local defenderBattleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(defenderTeamData)
            ---@type BattleTeamInfo
            local attackerBattleTeamInfo = ClientConfigUtils.GetAttackCurrentBattleTeamInfoByMode(gameMode, InventoryUtils.Get(ResourceType.Hero))
            zg.battleMgr:RunCalculatedBattleScene(attackerBattleTeamInfo, defenderBattleTeamInfo, gameMode, nil, nil, battleLog)
        end
        ---@param battleResultInBound BattleResultInBound
        local callbackSuccess = function(battleResultInBound)
            if battleResultInBound.isWin then
                zg.playerData.rewardList = rewardList
                zg.playerData:AddListRewardToInventory()
                towerInBound:SetDataTowerAfterWin()
                TrackingUtils.SetStage(AFInAppEvents.TOWER, towerInBound.levelCurrent)
                PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.TOWER }, showNextBattle(battleResultInBound.battleLog))
            else
                zg.playerData.rewardList = nil
                if InventoryUtils.GetMoney(MoneyType.TOWER_STAMINA) == towerConfig.maxStamina - 1 then
                    towerInBound:SetLastFreeStamina(zg.timeMgr:GetServerTime())
                end
                RxMgr.mktTracking:Next(MktTrackingType.towerLost, 1)
                showNextBattle(battleResultInBound.battleLog)
            end
            InventoryUtils.Sub(ResourceType.Money, MoneyType.TOWER_STAMINA, 1)
        end
        local onFailed = function(logicCode)
            if logicCode == LogicCode.TOWER_STAGE_INVALID then
                PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.TOWER }, function()
                    PopupMgr.ShowPopup(UIPopupName.UITower)
                end)
            end
            self:OnClickBackOrClose()
        end
        local teamFormation = TeamFormationInBound.Clone(zg.playerData:GetFormationInBound().teamDict:Get(gameMode))
        local uiFormationTeamData = UIFormationTeamData.CreateByTeamFormationInBound(teamFormation)
        BattleFormationRequest.BattleRequest(OpCode.TOWER_CHALLENGE,
                uiFormationTeamData, selectedLevel, callbackSuccess, onFailed)
    else
        self:OnClickBackOrClose()
    end
end

function UIVictoryPveLayout:UpdateImageAnim()
    self.animIndex = math.max(1, (self.animIndex + 1) % 8)
    local sprite = ResourceLoadUtils.LoadSpriteFromAtlas("RufusRun", "icon_loading_rufus_0" .. self.animIndex)
    self.layoutConfig.rufusImage.sprite = sprite
end

function UIVictoryPveLayout:OnClickBgAutoBattle()
    self.layoutConfig.autoBattleView.gameObject:SetActive(false)

    PlayerSetting.SetAutoNextBattle(false)

    self:StopCoroutine()
end

function UIVictoryPveLayout:StopCoroutine()
    if (self.coroutineWaitNextBattle) then
        ClientConfigUtils.KillCoroutine(self.coroutineWaitNextBattle)
        self.coroutineWaitNextBattle = nil
    end
    if self.coroutineUpdateLoadingImage then
        ClientConfigUtils.KillCoroutine(self.coroutineUpdateLoadingImage)
        self.coroutineUpdateLoadingImage = nil
    end
end

function UIVictoryPveLayout:OnHide()
    UIVictoryLayout.OnHide(self)
    self.config.autoBattleView.gameObject:SetActive(false)
    self:StopCoroutine()
end