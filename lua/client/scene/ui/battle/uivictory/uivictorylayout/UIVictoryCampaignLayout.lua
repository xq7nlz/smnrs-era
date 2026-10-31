--- @class UIVictoryCampaignLayout : UIVictoryLayout
UIVictoryCampaignLayout = Class(UIVictoryCampaignLayout, UIVictoryLayout)

function UIVictoryCampaignLayout:InitLayoutConfig()
    --- @type UIVictoryPveLayoutConfig
    self.layoutConfig = UIBaseConfig(self.anchor)

    self.layoutConfig.autoBattleView.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBgAutoBattle()
    end)

    self.animIndex = 0
end

function UIVictoryCampaignLayout:SetUpLayout()
    UIVictoryLayout.SetUpLayout(self)
    self.config.rewardAnchor.anchoredPosition3D = U_Vector3(0, -40, 0)
end

--- @param data {}
function UIVictoryCampaignLayout:ShowData(data)
    if zg.playerData ~= nil and zg.playerData:HasReward() then
        self.view:SetReward(zg.playerData.rewardList)
    end
    if not data.isSkip then
        self.config.autoBattleView.gameObject:SetActive(PlayerSettingData.isAutoNextBattle)
        if PlayerSettingData.isAutoNextBattle and self.view.model.isWin == true then
            self:DoCountdownAutoNext()
        end
    end
end

function UIVictoryCampaignLayout:CheckLevelUpAndUnlockFeature()
    if PlayerSettingData.isAutoNextBattle == true then
        return
    end
    --- @type number
    local stageIdle = zg.playerData:GetCampaignData().stageIdle
    ClientConfigUtils.CheckLevelUpAndUnlockFeature(stageIdle)
end

function UIVictoryCampaignLayout:OnFinishAnimation()
    UIVictoryLayout.OnFinishAnimation(self)
    self.view:CheckAndInitTutorial()
end

function UIVictoryCampaignLayout:DoCountdownAutoNext()
    self.coroutineWaitNextBattle = Coroutine.start(function()
        ---@type number
        local numberOfSecs = 5

        local campaignData = zg.playerData:GetCampaignData()
        local difficultLevel, mapIdNext, stageNext = ClientConfigUtils.GetIdFromStageId(campaignData.stageNext)
        while (numberOfSecs > 0) do
            self.layoutConfig.textAutoEnd.text = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("auto_battle_end_in"),
                    LanguageUtils.LocalizeDifficult(difficultLevel), tostring(mapIdNext), tostring(stageNext), tostring(numberOfSecs))
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

function UIVictoryCampaignLayout:OnClickBgAutoBattle()
    self.layoutConfig.autoBattleView.gameObject:SetActive(false)

    PlayerSetting.SetAutoNextBattle(false)

    self:StopCoroutine()
end

function UIVictoryCampaignLayout:StopCoroutine()
    if (self.coroutineWaitNextBattle) then
        ClientConfigUtils.KillCoroutine(self.coroutineWaitNextBattle)
        self.coroutineWaitNextBattle = nil
    end
    if self.coroutineUpdateLoadingImage then
        ClientConfigUtils.KillCoroutine(self.coroutineUpdateLoadingImage)
        self.coroutineUpdateLoadingImage = nil
    end
end

function UIVictoryCampaignLayout:OnHide()
    UIVictoryLayout.OnHide(self)
    self.config.autoBattleView.gameObject:SetActive(false)

    self:StopCoroutine()
end

function UIVictoryCampaignLayout:UpdateImageAnim()
    self.animIndex = math.max(1, (self.animIndex + 1) % 8)
    local sprite = ResourceLoadUtils.LoadSpriteFromAtlas("RufusRun", "icon_loading_rufus_0" .. self.animIndex)
    self.layoutConfig.rufusImage.sprite = sprite
end

function UIVictoryCampaignLayout:ChallengeNextStage()
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
end