require "lua.client.scene.ui.common.TowerResultItemView"
require "lua.client.core.network.defenseMode.DefenseChallengeOutBound"

--- @class UIVictoryDefenseLayout : UIVictoryLayout
UIVictoryDefenseLayout = Class(UIVictoryDefenseLayout, UIVictoryLayout)

function UIVictoryDefenseLayout:InitLayoutConfig()
    --- @type UIVictoryConfig
    self.layoutConfig = UIBaseConfig(self.anchor)
    self.animIndex = 0
end

function UIVictoryDefenseLayout:InitCancelAutoNextBattle()
    self.layoutConfig.autoBattleView.onClick:RemoveAllListeners()
    self.layoutConfig.autoBattleView.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBgAutoBattle()
    end)
end

function UIVictoryDefenseLayout:SetUpLayout()
    UIVictoryLayout.SetUpLayout(self)
    self.config.rewardAnchor.anchoredPosition3D = U_Vector3(0, -40, 0)
    self.config.buttonBattleLog.gameObject:SetActive(false)
end

--- @param data {gameMode : GameMode, isWin : boolean, result, clientLogDetail}
function UIVictoryDefenseLayout:ShowData(data)
    self.data = data
    if zg.playerData ~= nil and zg.playerData:HasReward() then
        self.view:SetReward(zg.playerData.rewardList)
    end
    if not data.isSkip and data.gameMode == GameMode.DEFENSE_MODE then
        self:InitCancelAutoNextBattle()
        self.config.autoBattleView.gameObject:SetActive(PlayerSettingData.isAutoNextBattle)
        if PlayerSettingData.isAutoNextBattle and self.view.model.isWin == true then
            self:DoCountdownAutoNext()
        end
    end
end

function UIVictoryDefenseLayout:OnFinishAnimation()
    UIVictoryLayout.OnFinishAnimation(self)
    self.view:CheckAndInitTutorial()
end

function UIVictoryDefenseLayout:DoCountdownAutoNext()
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

function UIVictoryDefenseLayout:ChallengeNextStage()
    --- @type DefenseModeInbound
    local defenseModeInbound = zg.playerData:GetMethod(PlayerDataMethod.DEFENSE_MODE)
    ---@type {land, teamFormationInBound)}
    local data = defenseModeInbound:GetCurrentBattleData()
    ---@type number
    local stage = 0
    ---@type LandCollectionData
    local landCollectionData = defenseModeInbound.landCollectionDataMap:Get(data.land)
    if landCollectionData ~= nil and landCollectionData.stage > 0 then
        stage = landCollectionData.stage
    end
    ---@type LandConfig
    local landConfig = ResourceMgr.GetDefenseModeConfig():GetLandConfig(data.land)
    local canBattle = stage + 1 <= landConfig.dictLandIdleRewardConfig:Count()
    if canBattle then
        local nextStage = math.min(stage + 1, landConfig.dictLandIdleRewardConfig:Count())
        local listAttackerTeamStageConfig = landConfig:GetListAttackerTeamStageConfig(nextStage)
        local teamFormation = UIFormationTeamData.CreateByTeamFormationInBound(data.teamFormationInBound)
        local callbackSuccess = function()
            zg.battleMgr.gameMode = self.currentMode
            defenseModeInbound.defenseChallengeResultInBound:RunTheFirstBattle(data.teamFormationInBound,
                    listAttackerTeamStageConfig, data.land)
        end
        local onChallengeSuccess = function(defenseChallengeResultInBound)
            zg.playerData.rewardList = RewardInBound.GetItemIconDataList(defenseChallengeResultInBound.listReward)
            if defenseChallengeResultInBound.isWin == true then
                PlayerDataRequest.Request(PlayerDataMethod.DEFENSE_MODE)
            end
            defenseModeInbound:SaveCurrentBattleData(data)
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
            zg.playerData:AddListRewardToInventory()
            zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
        end
        DefenseModeInbound.ChallengeDefense(BattleFormationOutBound(teamFormation), data.land, nextStage, onChallengeSuccess)
    else
        self:OnClickBackOrClose()
    end
end

function UIVictoryDefenseLayout:UpdateImageAnim()
    self.animIndex = math.max(1, (self.animIndex + 1) % 8)
    local sprite = ResourceLoadUtils.LoadSpriteFromAtlas("RufusRun", "icon_loading_rufus_0" .. self.animIndex)
    self.layoutConfig.rufusImage.sprite = sprite
end

function UIVictoryDefenseLayout:OnClickBgAutoBattle()
    self.layoutConfig.autoBattleView.gameObject:SetActive(false)

    PlayerSetting.SetAutoNextBattle(false)

    self:StopCoroutine()
end

function UIVictoryDefenseLayout:StopCoroutine()
    if (self.coroutineWaitNextBattle) then
        ClientConfigUtils.KillCoroutine(self.coroutineWaitNextBattle)
        self.coroutineWaitNextBattle = nil
    end
    if self.coroutineUpdateLoadingImage then
        ClientConfigUtils.KillCoroutine(self.coroutineUpdateLoadingImage)
        self.coroutineUpdateLoadingImage = nil
    end
end

function UIVictoryDefenseLayout:OnHide()
    UIVictoryLayout.OnHide(self)
    self.config.autoBattleView.gameObject:SetActive(false)
    self:StopCoroutine()
end