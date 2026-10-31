require "lua.client.scene.ui.home.uiGuildWarRegistration.uiGuildWarRegistrationLayout.UIGuildWarRegistrationLayout"

--- @class UIGuildWarRegistrationView : UIBaseView
UIGuildWarRegistrationView = Class(UIGuildWarRegistrationView, UIBaseView)

--- @return void
--- @param model UIGuildWarRegistrationModel
function UIGuildWarRegistrationView:Ctor(model)
    --- @type UIGuildWarRegistrationConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollMember = nil
    --- @type GuildWarDataConfig
    self.csvConfig = nil
    --- @type GuildWarPhase
    self.currentPhase = nil

    --- @type GuildWarTimeInBound
    self.guildWarTimeInBound = nil
    --- @type GuildBasicInfoInBound
    self.guildBasicInfo = nil
    --- @type GuildWarInBound
    self.guildWarInBound = nil

    --- @type UIGuildWarRegistrationLayout
    self.currentLayout = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    UIBaseView.Ctor(self, model)
    --- @type UIGuildWarRegistrationModel
    self.model = model
end

--- @return void
function UIGuildWarRegistrationView:OnReadyCreate()
    ---@type UIGuildWarRegistrationConfig
    self.config = UIBaseConfig(self.uiTransform)
    uiCanvas:SetBackgroundSize(self.config.backGround)

    self:_InitButtonListener()
    self:_InitUpdateTime()
    self.csvConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig()
end

function UIGuildWarRegistrationView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeGameMode(GameMode.GUILD_WAR)
    self.config.textMessageTittle.text = LanguageUtils.LocalizeCommon("phase_message_tittle")
    self.config.localizeChangeFormation.text = LanguageUtils.LocalizeCommon("change_formation")
    self.config.textCheckOutDefender.text = LanguageUtils.LocalizeCommon("check_out_defenders")
    self.config.guildLeaderBenefit.text = LanguageUtils.LocalizeCommon("guild_leader_benefit")
end

function UIGuildWarRegistrationView:_InitButtonListener()
    self.config.backButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickInfo()
    end)
    self.config.buttonChangeFormation.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChangeFormation()
    end)
    self.config.buttonCheckOutDefender.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCheckOutDefender()
    end)
    self.config.buttonLeaderboard.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLeaderBoard()
    end)
    self.config.buttonReward.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickReward()
    end)
end

function UIGuildWarRegistrationView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
    PopupMgr.ShowPopup(UIPopupName.UIGuildArea)
end

function UIGuildWarRegistrationView:OnClickInfo()
    local info = LanguageUtils.LocalizeHelpInfo("registration_phase_info")
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

function UIGuildWarRegistrationView:ShowGuildInfo()
    self.config.iconGuild.sprite = ResourceLoadUtils.LoadGuildIcon(self.guildBasicInfo.guildInfo.guildAvatar)
    self.config.iconGuild:SetNativeSize()
    self.config.guildName.text = self.guildBasicInfo.guildInfo.guildName

    local registeredMember = self.guildWarInBound:CountTotalParticipants()
    local minRequire = self.csvConfig:GetGuildWarConfig().numberMemberJoin
    local color = UIUtils.color2
    if registeredMember < minRequire then
        color = UIUtils.color7
    end
    self.config.registrationCount.text = string.format("%s: <color=#%s>%d/%d</color>", LanguageUtils.LocalizeCommon("registered_member"), color,
            registeredMember, self.csvConfig:GetGuildWarConfig().numberMemberJoin)
end

function UIGuildWarRegistrationView:OnReadyShow()
    self.guildWarTimeInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR_TIME)
    self.guildBasicInfo = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
    self.guildWarInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR)

    self.config.npc.AnimationState:SetAnimation(0, "start", false)
    self.config.npc.AnimationState:AddAnimation(0, "idle", true, 0)

    self:GetLayout()
    self.currentLayout:OnShow()
    self:StartUpdateTime()

    self.listener = RxMgr.guildWarRegistered:Subscribe(RxMgr.CreateFunction(self, self.OnGuildUpdated))
end

function UIGuildWarRegistrationView:_InitUpdateTime()
    local onTimeEnded = function()
        self:RemoveUpdateTime()
        self:OnClickBackOrClose()
        SmartPoolUtils.ShowShortNotification(string.format("%s %s",
                LanguageUtils.LocalizeCommon(string.format("guild_war_phase_%s_name", self.currentPhase)),
                LanguageUtils.LocalizeCommon("event_has_ended")))
            PopupMgr.HidePopup(UIPopupName.UIGuildWarReward)
    end
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        local format = string.format("%s %s",
                LanguageUtils.LocalizeCommon(string.format("guild_war_phase_%s_name", self.currentPhase)),
                LanguageUtils.LocalizeCommon("will_end_in"))
        if isSetTime == true then
            if self.currentPhase == self.guildWarTimeInBound:CurrentPhase() then
                self.timeRefresh = self.guildWarTimeInBound:GetTimeToCurrentPhaseEnd()
            else
                onTimeEnded()
            end
        else
            self.timeRefresh = self.timeRefresh - 1
            if self.timeRefresh >= 0 then
                self.config.textPhaseTimer.text = string.format("%s %s", format,
                        UIUtils.SetColorString(UIUtils.green_light, TimeUtils.SecondsToClock(self.timeRefresh)))
            else
                onTimeEnded()
            end
        end
    end
end

function UIGuildWarRegistrationView:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIGuildWarRegistrationView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIGuildWarRegistrationView:Hide()
    UIBaseView.Hide(self)
    self:RemoveUpdateTime()
    if self.scrollMember ~= nil then
        self.scrollMember:Hide()
    end
    self.currentLayout:OnHide()

    if self.listener ~= nil then
        self.listener:Unsubscribe()
        self.listener = nil
    end
end

function UIGuildWarRegistrationView:OnClickChangeFormation()
    local result = {}
    result.gameMode = GameMode.GUILD_WAR
    result.tittle = LanguageUtils.LocalizeCommon("save")
    result.callbackClose = function()
        PopupMgr.HidePopup(UIPopupName.UIFormation2)
        PopupMgr.ShowPopup(UIPopupName.UIGuildWarRegistration)
    end
    result.callbackPlayBattle = function(uiFormationTeamData)
        local onRegisterSuccess = function()
            result.callbackClose()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("save_successful"))
        end
        self.guildWarInBound:RegisterMemberForGuildWar(uiFormationTeamData, onRegisterSuccess)
    end
    PopupMgr.HidePopup(UIPopupName.UIGuildWarRegistration)
    PopupMgr.ShowPopup(UIPopupName.UIFormation2, result)
end

function UIGuildWarRegistrationView:OnClickCheckOutDefender()
    PopupMgr.HidePopup(UIPopupName.UIGuildWarRegistration)
    PopupMgr.ShowPopup(UIPopupName.UIGuildWarSetup)
end

function UIGuildWarRegistrationView:OnClickLeaderBoard()
    PopupMgr.ShowPopup(UIPopupName.UILeaderBoard, LeaderBoardType.GUILD_WAR_SEASON_RANKING)
end

function UIGuildWarRegistrationView:GetLayout()
    local currentPhase = self.guildWarTimeInBound:CurrentPhase()
    local layoutType = GuildWarRegistrationLayoutType.CHECK_OUT_REGISTRATION
    if currentPhase == GuildWarPhase.SETUP_DEFENDER then
        layoutType = GuildWarRegistrationLayoutType.CHECK_OUT_SELECTED
    end
    self.currentLayout = self.layoutDict:Get(layoutType)
    if self.currentLayout == nil then
        if layoutType == GuildWarRegistrationLayoutType.CHECK_OUT_REGISTRATION then
            require "lua.client.scene.ui.home.uiGuildWarRegistration.uiGuildWarRegistrationLayout.UIGuildWarCheckOutRegistrationLayout"
            self.currentLayout = UIGuildWarCheckOutRegistrationLayout(self)
        elseif layoutType == GuildWarRegistrationLayoutType.CHECK_OUT_SELECTED then
            require "lua.client.scene.ui.home.uiGuildWarRegistration.uiGuildWarRegistrationLayout.UIGuildWarCheckOutSelectedLayout"
            self.currentLayout = UIGuildWarCheckOutSelectedLayout(self)
        end
        self.layoutDict:Add(layoutType, self.currentLayout)
    end
    self:DisableAllButtons()
end

function UIGuildWarRegistrationView:DisableAllButtons()
    self.config.buttonCheckOutDefender.gameObject:SetActive(false)
    self.config.buttonChangeFormation.gameObject:SetActive(false)
    self.config.guildLeaderBenefit.gameObject:SetActive(false)
end

function UIGuildWarRegistrationView:OnGuildUpdated()
    local update = function()
        GuildWarInBound.ValidateData(function()
            self.guildWarInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR)
            self.currentLayout:OnDefenderUpdated()
        end, true, true)
    end
    PopupUtils.ShowPopupNotificationOK(LanguageUtils.LocalizeCommon("guild_war_register_notification"), update, update)
end

function UIGuildWarRegistrationView:OnClickReward()
    PopupMgr.ShowPopup(UIPopupName.UIGuildWarReward)
end