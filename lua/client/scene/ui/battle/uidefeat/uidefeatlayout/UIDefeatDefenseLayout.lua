--- @class UIDefeatDefenseLayout : UIDefeatLayout
UIDefeatDefenseLayout = Class(UIDefeatDefenseLayout, UIDefeatLayout)

function UIDefeatDefenseLayout:SetUpLayout()
    UIDefeatLayout.SetUpLayout(self)
    self.config.rewardAnchor.anchoredPosition3D = U_Vector3(0, -40, 0)
    self.config.recommendAnchor.anchoredPosition3D = U_Vector3(0, -40, 0)
    self.config.buttonBattleLog.gameObject:SetActive(false)
end

--- @param data {gameMode: GameMode, result, clientLogDetail, isSkip}
function UIDefeatDefenseLayout:ShowData(data)
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
        local isEnable = data.gameMode == GameMode.DEFENSE_MODE
        self.view:SetActiveAutoNextBattle(isEnable)
        if isEnable then
            self:DoCountdownAutoNext()
        end
    end
end

function UIDefeatDefenseLayout:CheckLevelUpAndUnlockFeature()
    --- @type number
    local stageIdle = zg.playerData:GetCampaignData().stageIdle
    ClientConfigUtils.CheckLevelUpAndUnlockFeature(stageIdle)
end

function UIDefeatDefenseLayout:OnFinishAnimation()
    UIDefeatLayout.OnFinishAnimation(self)
    self.view:CheckAndInitTutorial()
end

function UIDefeatDefenseLayout:OnHide()
    UIDefeatLayout.OnHide()
    self.config.recommendAnchor.gameObject:SetActive(false)
    self.view:SetActiveAutoNextBattle(false)
    self:StopCoroutine()
end

function UIDefeatDefenseLayout:ChallengeCurrentStageAgain()
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