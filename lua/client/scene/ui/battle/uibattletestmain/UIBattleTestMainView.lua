require "lua.client.scene.ui.battle.uiBattleMain.SummonerWrathView"

--- @class UIBattleTestMainView : UIBaseView
UIBattleTestMainView = Class(UIBattleTestMainView, UIBaseView)

--- @return void
--- @param model UIBattleMainModel
--- @param ctrl UIBaseCtrl
function UIBattleTestMainView:Ctor(model, ctrl)
    --- @type BattleMainConfig
    self.config = nil
    --- @type SummonerWrathView
    self.attackerWrathView = nil
    --- @type SummonerWrathView
    self.defenderWrathView = nil
    --- @type UIButtonSpeedUp
    self.buttonSpeedUp1 = nil
    --- @type UIButtonSpeedUp
    self.buttonSpeedUp2 = nil

    UIBaseView.Ctor(self, model, ctrl)
end

--- @return void
function UIBattleTestMainView:OnReadyCreate()
    self:InitUI()
    self:InitListener()

    self.buttonSpeedUp1 = UIButtonSpeedUp(self.config.buttonSpeedUp1, 2)
    self.buttonSpeedUp1:AddOnClickListener(function ()
        self:OnClickButtonSpeedUp(MinorFeatureType.BATTLE_SPEED_UP)
    end)
    self.buttonSpeedUp2 = UIButtonSpeedUp(self.config.buttonSpeedUp2, 3)
    self.buttonSpeedUp2:AddOnClickListener(function ()
        self:OnClickButtonSpeedUp(MinorFeatureType.BATTLE_SPEED_UP_2)
    end)
end

--- @return void
function UIBattleTestMainView:InitUI()
    ---@type BattleMainConfig
    self.config = UIBaseConfig(self.uiTransform)

    self.config.buttonSkip.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSkip()
    end)

    self.config.buttonCompanionAttacker.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCompanionTeam(ClientBattleData.clientLogDetail.attackerTeam)
    end)

    self.config.buttonCompanionDefender.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCompanionTeam(ClientBattleData.clientLogDetail.defenderTeam)
    end)

    self.config.buttonInfo.onClick:AddListener(function()
        PopupMgr.ShowPopup(UIPopupName.UIFactionInfo)
    end)

    self.config.buttonSkipVideo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickToggleSkipVideo()
    end)
end

function UIBattleTestMainView:InitLocalization()
    self.config.textRound.text = LanguageUtils.LocalizeCommon("round")
end

--- @return void
function UIBattleTestMainView:OnClickSkip()
    RxMgr.skipBattle:Next()
end

---@return void
---@param team ClientTeamDetail
function UIBattleTestMainView:OnClickCompanionTeam(team)
    local data = {}
    data.companionId = team.companionBuffId
    ---@param v BaseHero
    for _, v in pairs(team.baseHeroList:GetItems()) do
        if v.isSummoner then
            data.summonerId = v.id
            data.summonerStar = v.star
            break
        end
    end
    data.callbackClose = function()
        PopupMgr.HidePopup(UIPopupName.UICompanionCollection)
    end
    PopupMgr.ShowPopup(UIPopupName.UICompanionCollection, data)
end

function UIBattleTestMainView:SetSpeedOnStart()
    PlayerSettingData.battleSpeed = 2
    self:SetViewBattleSpeed()
end

--- @return void
function UIBattleTestMainView:SetViewBattleSpeed()
    self.buttonSpeedUp1:EnableState(PlayerSettingData.battleSpeed == 2)
    self.buttonSpeedUp2:EnableState(PlayerSettingData.battleSpeed == 3)
    RxMgr.battleSpeed:Next(ClientConfigUtils.GetTimeScaleBySpeedUpLevel(PlayerSettingData.battleSpeed))
end

--- @return void
function UIBattleTestMainView:InitListener()
    RxMgr.updateRound:Subscribe(RxMgr.CreateFunction(self, self.ShowRound))
    RxMgr.finishTurn:Subscribe(RxMgr.CreateFunction(self, self.OnNextTurn))
end

--- @return void
function UIBattleTestMainView:OnReadyShow()
    self:SetSpeedOnStart()
    self:CheckCanSkip()
    self.updateBattleUiListener = RxMgr.updateBattleUI:Subscribe(RxMgr.CreateFunction(self, self.UpdateBattleUi))
    self:LoadBattle()
    self:CheckSkipVideo()

    self.config.xmasDamageView:SetActive(false)
end

--- @return void
function UIBattleTestMainView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self:CheckAndInitTutorial()
end

--- @return void
function UIBattleTestMainView:OnReadyHide()
    -- do nothing when battle showing
end

--- @return void
function UIBattleTestMainView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListenerTutorial()
end

function UIBattleTestMainView:RemoveListener()
    if self.updateBattleUiListener ~= nil then
        self.updateBattleUiListener:Unsubscribe()
        self.updateBattleUiListener = nil
    end
end

--- @return void
function UIBattleTestMainView:CheckCanSkip()
    self.config.buttonSkip.gameObject:SetActive(true)
end

--- @return void
--- @param eventData {round, useMotion}
function UIBattleTestMainView:ShowRound(eventData)
    self.config.textNumberRound.text = string.format("%s/%s", tostring(eventData.round), BattleConstants.MAX_ROUND)
    if eventData.useMotion == true then
        self.config.tweenRound:DORewindAndPlayNext()
    end
end

--- @return void
function UIBattleTestMainView:OnNextTurn()

end

--- @param attackerSummoner BaseHero
--- @param defenderSummoner BaseHero
function UIBattleTestMainView:InitTeamWrathView(attackerSummoner, defenderSummoner)
    if attackerSummoner ~= nil and attackerSummoner.isDummy == false then
        self.attackerWrathView = SummonerWrathView(self.config.attackerWrath)
        self.attackerWrathView:SetAvatar(ResourceLoadUtils.LoadBattleSummonerIcon(
                attackerSummoner.id,
                ClientConfigUtils.GetSkinLevelByStar(attackerSummoner.id, attackerSummoner.star)))
        self.config.attackerWrath.gameObject:SetActive(true)
    else
        self.config.attackerWrath.gameObject:SetActive(false)
    end
    if defenderSummoner ~= nil and defenderSummoner.isDummy == false then
        self.defenderWrathView = SummonerWrathView(self.config.defenderWrath)
        self.defenderWrathView:SetAvatar(ResourceLoadUtils.LoadBattleSummonerIcon(
                defenderSummoner.id,
                ClientConfigUtils.GetSkinLevelByStar(defenderSummoner.id, defenderSummoner.star)))
        self.config.defenderWrath.gameObject:SetActive(true)
    else
        self.config.defenderWrath.gameObject:SetActive(false)
    end
end

--- @param attackerCompanionsId number
--- @param defenderCompanionsId number
function UIBattleTestMainView:ShowIconCompanions(attackerCompanionsId, defenderCompanionsId)
    if attackerCompanionsId ~= nil then
        self.config.attackerIconCompanions.color = U_Color.white
        self.config.attackerIconCompanions.sprite = ResourceLoadUtils.LoadCompanionBuffOnIcon(attackerCompanionsId)
    else
        self.config.attackerIconCompanions.sprite = ResourceLoadUtils.LoadCompanionBuffOnIcon(0)
    end
    if defenderCompanionsId ~= nil then
        self.config.defenderIconCompanions.color = U_Color.white
        self.config.defenderIconCompanions.sprite = ResourceLoadUtils.LoadCompanionBuffOnIcon(defenderCompanionsId)
    else
        self.config.defenderIconCompanions.sprite = ResourceLoadUtils.LoadCompanionBuffOnIcon(0)
    end
end

--- @param teamId number
--- @param powerAmount number
--- @param useTween boolean
function UIBattleTestMainView:UpdateTeamWrathPower(teamId, powerAmount, useTween)
    if teamId == BattleConstants.ATTACKER_TEAM_ID and self.attackerWrathView ~= nil then
        self.attackerWrathView:SetPowerData(powerAmount, useTween)
    elseif teamId == BattleConstants.DEFENDER_TEAM_ID and self.defenderWrathView ~= nil then
        self.defenderWrathView:SetPowerData(powerAmount, useTween)
    end
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIBattleTestMainView:ShowTutorial(tutorial, step)
end

--- @param data {}
function UIBattleTestMainView:UpdateBattleUi(data)
    --- @type {attackerSummoner : BaseHero, defenderSummoner : BaseHero}
    local initTeamWrathView = data.initTeamWrathView
    if initTeamWrathView ~= nil then
        self:InitTeamWrathView(initTeamWrathView.attackerSummoner, initTeamWrathView.defenderSummoner)
    end

    --- @type {teamId : number, powerAmount : number, useTween : boolean}
    local updateTeamWrathPower = data.updateTeamWrathPower
    if updateTeamWrathPower ~= nil then
        self:UpdateTeamWrathPower(updateTeamWrathPower.teamId,
                updateTeamWrathPower.powerAmount,
                updateTeamWrathPower.useTween)
    end

    --- @type {attackerCompanionsId : number, defenderCompanionsId : number}
    local companionBuff = data.companionBuff
    if companionBuff ~= nil then
        self:ShowIconCompanions(companionBuff.attackerCompanionsId, companionBuff.defenderCompanionsId)
    end
end

--- @return void
function UIBattleTestMainView:LoadBattle()
    if ClientBattleData.IsValidData() then
        zg.battleMgr:ShowBattleFromResult()
    else
        XDebug.Log("data is not valid")
    end
end

function UIBattleTestMainView:OnClickToggleSkipVideo()
    PlayerSetting.ToggleSkipVideoBattle()
    self:SetButtonSkipVideoState(PlayerSettingData.isSkipVideoBattle)
    UIBattleTestTool.NotificationToggleSkipVideo()
end

function UIBattleTestMainView:SetButtonSkipVideoState(isSkip)
    local btnRect = self.config.buttonSkipVideo.transform
    btnRect:GetChild(0).gameObject:SetActive(isSkip)
    btnRect:GetChild(1).gameObject:SetActive(not isSkip)
end

function UIBattleTestMainView:CheckSkipVideo()
    local isSupportCutScene = not LOWER_DEVICE
    self.config.buttonSkipVideo.gameObject:SetActive(isSupportCutScene)
    if isSupportCutScene == true then
        self:SetButtonSkipVideoState(PlayerSettingData.isSkipVideoBattle)
    end
end

--- @param minorFeatureType MinorFeatureType
function UIBattleTestMainView:OnClickButtonSpeedUp(minorFeatureType)
    ClientConfigUtils.ChangeSpeedUpAndSave(minorFeatureType, function ()
        self:SetViewBattleSpeed()
    end)
end