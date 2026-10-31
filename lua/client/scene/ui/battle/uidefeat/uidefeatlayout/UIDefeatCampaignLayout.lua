--- @class UIDefeatCampaignLayout : UIDefeatLayout
UIDefeatCampaignLayout = Class(UIDefeatCampaignLayout, UIDefeatLayout)

function UIDefeatCampaignLayout:SetUpLayout()
    UIDefeatLayout.SetUpLayout(self)
    self.config.rewardAnchor.anchoredPosition3D = U_Vector3(0, -40, 0)
    self.config.recommendAnchor.anchoredPosition3D = U_Vector3(0, -40, 0)
end

--- @param data {gameMode: GameMode, result, clientLogDetail, isSkip}
function UIDefeatCampaignLayout:ShowData(data)
    self.data = data
    if zg.playerData ~= nil and zg.playerData:HasReward() then
        self.config.recommendAnchor.gameObject:SetActive(false)
        self.config.rewardAnchor.gameObject:SetActive(true)
        self.view:SetReward(zg.playerData.rewardList)
    else
        self.config.recommendAnchor.gameObject:SetActive(true)
        self.config.rewardAnchor.gameObject:SetActive(false)
    end

    if PlayerSettingData.isAutoNextBattle and not data.isSkip then
        --PlayerSetting.SetAutoNextBattle(false)
        --PopupUtils.ShowPopupNotificationOK(LanguageUtils.LocalizeCommon("auto_next_battle_off"), nil)
        local isEnable = data.gameMode == GameMode.CAMPAIGN or data.gameMode == GameMode.TOWER
        self.view:SetActiveAutoNextBattle(isEnable)
        if isEnable then
            self:DoCountdownAutoNext()
        end
    end
end

function UIDefeatCampaignLayout:CheckLevelUpAndUnlockFeature()
    --- @type number
    local stageIdle = zg.playerData:GetCampaignData().stageIdle
    ClientConfigUtils.CheckLevelUpAndUnlockFeature(stageIdle)
end

function UIDefeatCampaignLayout:OnFinishAnimation()
    UIDefeatLayout.OnFinishAnimation(self)
    self.view:CheckAndInitTutorial()
end

function UIDefeatCampaignLayout:OnHide()
    UIDefeatLayout.OnHide()
    self.config.recommendAnchor.gameObject:SetActive(false)
    self.view:SetActiveAutoNextBattle(false)
    self:StopCoroutine()
end

function UIDefeatCampaignLayout:ChallengeCurrentStageAgain()
    if self.data.gameMode == GameMode.CAMPAIGN then
        local campaignData = zg.playerData:GetCampaignData()
        local nextStage = campaignData.stageNext
        local levelRequired = ResourceMgr.GetCampaignDataConfig():GetLevelRequired(nextStage)
        ---@type BasicInfoInBound
        local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
        if levelRequired == nil or basicInfoInBound.level < levelRequired then
            self:OnClickBackOrClose()
            return
        end
        local gameMode = GameMode.CAMPAIGN
        ---@type DefenderTeamData
        local dataStage = ResourceMgr.GetCampaignDataConfig():GetCampaignStageConfigById(nextStage)
        ---@type BattleTeamInfo
        local defenderBattleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(dataStage)

        local showNextBattle = function(battleLog)
            ---@type BattleTeamInfo
            local attackerBattleTeamInfo = ClientConfigUtils.GetAttackCurrentBattleTeamInfoByMode(gameMode, InventoryUtils.Get(ResourceType.Hero))
            zg.battleMgr:RunCalculatedBattleScene(attackerBattleTeamInfo, defenderBattleTeamInfo, gameMode, nil, nil, battleLog)
        end

        ---@param battleResultInBound BattleResultInBound
        local callbackSuccess = function(battleResultInBound, listRewardEvent)
            if battleResultInBound.isWin == true then
                UISelectMapPVEView.OnWinChallengeCampaignStage(nextStage, listRewardEvent)

                PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.CAMPAIGN }, showNextBattle(battleResultInBound.battleLog))
            else
                zg.playerData.rewardList = nil
                showNextBattle(battleResultInBound.battleLog)
            end
        end

        local onFailed = function()
            self:OnClickBackOrClose()
        end

        local teamFormation = TeamFormationInBound.Clone(zg.playerData:GetFormationInBound().teamDict:Get(gameMode))
        local uiFormationTeamData = UIFormationTeamData.CreateByTeamFormationInBound(teamFormation)
        BattleFormationRequest.BattleRequestInjectRewardEvent(OpCode.CAMPAIGN_CHALLENGE, uiFormationTeamData, nextStage, callbackSuccess, onFailed)
        UISelectMapPVEView.UpdateCampaignTeamFormationData(uiFormationTeamData)
    elseif self.data.gameMode == GameMode.TOWER then
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
end