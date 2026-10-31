require "lua.client.scene.ui.home.uiDomainTeam.DomainTeamWorld"

--- @class UIDomainTeamView : UIBaseView
UIDomainTeamView = Class(UIDomainTeamView, UIBaseView)

--- @param model UIDomainTeamModel
function UIDomainTeamView:Ctor(model)
    --- @type UIDomainTeamConfig
    self.config = nil
    ---@type UILoopScroll
    self.uiScroll = nil
    ---@type DomainInBound
    self.domainInBound = nil
    --- @type DomainCrewInBound
    self.domainCrewInBound = nil
    --- @type DomainTeamWorld
    self.domainTeamWorld = nil
    UIBaseView.Ctor(self, model)
    --- @type UIDomainTeamModel
    self.model = model
end

function UIDomainTeamView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtons()

    --- @param obj UIDomainTeamItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        obj:SetData(self.domainCrewInBound.listMember:Get(index + 1), function(data)
            self:OnKickMember(data)
        end, function(data)
            self:OnChangeLeader(data)
        end, function (data)
            self:OnClickChangeTeam(data)
        end)
    end
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.UIDomainTeamItemView, onCreateItem, onCreateItem)

    self:ShowTicket()

    self:InitWorldFormation()
end

function UIDomainTeamView:InitWorldFormation()
    self.domainTeamWorld = DomainTeamWorld(self.config.domainTeamWorld)
end

function UIDomainTeamView:InitButtons()
    self.config.backButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonDisband.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickDisband()
    end)
    self.config.buttonInvite.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickInvite()
    end)
    self.config.buttonVerify.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickVerify()
    end)
    self.config.buttonStart.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickStart()
    end)

    self.config.buttonLeave.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLeave()
    end)

    self.config.buttonReady.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickReady(true)
    end)
    self.config.buttonUnReady.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickReady(false)
    end)
    self.config.buttonChat.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChat()
    end)
    self.config.iconHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelp()
    end)
end

--- @param data DomainsCrewMember
function UIDomainTeamView:OnKickMember(data)
    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("noti_kick_member"), nil, function()
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)

        end
        local callbackSuccess = function()
            self.domainCrewInBound.listMember:RemoveByReference(data)

            self:OnReadyShow()
        end
        local callbackFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            DomainInBound.Validate(function()
                self:OnReadyShow()
            end, true)
        end
        NetworkUtils.RequestAndCallback(OpCode.DOMAINS_CREW_MEMBER_KICK, UnknownOutBound.CreateInstance(PutMethod.Long, data.playerId), callbackSuccess, callbackFailed, onBufferReading)
    end)
end

--- @param data DomainsCrewMember
function UIDomainTeamView:OnChangeLeader(data)
    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("noti_change_leader"), nil, function()
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)

        end
        local callbackSuccess = function()
            self.domainCrewInBound:ChangeLeader(data.playerId)

            self:OnReadyShow()

            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("domain_leader_updated"))
        end
        local callbackFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            DomainInBound.Validate(function()
                self:OnReadyShow()
            end, true)
        end
        NetworkUtils.RequestAndCallback(OpCode.DOMAINS_CREW_LEADER_CHANGE, UnknownOutBound.CreateInstance(PutMethod.Long, data.playerId), callbackSuccess, callbackFailed, onBufferReading)
    end)
end

--- @return void
function UIDomainTeamView:OnClickBackOrClose()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIDomainTeam)
end

function UIDomainTeamView:InitLocalization()
    self.config.textChat.text = LanguageUtils.LocalizeCommon("chat")
    self.config.textStart.text = LanguageUtils.LocalizeCommon("start")
    self.config.textDisband.text = LanguageUtils.LocalizeCommon("disband")
    self.config.textInvite.text = LanguageUtils.LocalizeCommon("invite")
    self.config.textVerify.text = LanguageUtils.LocalizeCommon("verify")
    self.config.textLeave.text = LanguageUtils.LocalizeCommon("leave")
    self.config.textReady.text = LanguageUtils.LocalizeCommon("ready")
    self.config.textUnReady.text = LanguageUtils.LocalizeCommon("unready")
    self.config.textPoollist.text = LanguageUtils.LocalizeCommon("party")

    self.domainTeamWorld:InitLocalization()
end

--- @param data {callbackClose : function}
function UIDomainTeamView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)

    self:GetRefs()

    if self:CheckTeamValid() == false then
        return
    end
    if self.domainCrewInBound.isInBattle then
        self:GoToDefenseMapStage()
        return
    end

    self.uiScroll:Resize(self.domainCrewInBound.listMember:Count())

    self:ShowAllowedClasses()

    self.config.textName.text = self.domainCrewInBound.name
    self.config.textId.text = tostring(self.domainCrewInBound.crewId)

    self:InitListener()

    self:CheckNotificationChat()
    self:CheckNotificationApplication()

    self:UpdateLeaderMember()

    self:ShowMemberWorldState()
end

function UIDomainTeamView:InitListener()
    if self.listenerDomain == nil then
        self.listenerDomain = RxMgr.domainUpdated:Subscribe(RxMgr.CreateFunction(self, self.DomainUpdated))
    end
    if self.listenerChatMessage == nil then
        self.listenerChatMessage = RxMgr.notificationUnreadChatMessage:Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationChat))
    end
end

function UIDomainTeamView:GetRefs()
    ---@type DomainInBound
    self.domainInBound = zg.playerData:GetDomainInBound()
    self.domainCrewInBound = self.domainInBound.domainCrewInBound
end

function UIDomainTeamView:ShowAllowedClasses()
    self:ReturnPoolListClass()

    ---@type DailyTeamDomainConfig
    self.dailyTeamConfig = ResourceMgr.GetDomainConfig():GetDomainConfigByDay(self.domainInBound.challengeDay)
    if self.listClass == nil then
        self.listClass = List()
    end
    for i, v in ipairs(self.dailyTeamConfig.classRequire:GetItems()) do
        local requirementClass = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RequirementHeroIconView, self.config.demoClass)
        requirementClass.config.icon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconClassHeroes, v)
        self.listClass:Add(requirementClass)
    end
end

function UIDomainTeamView:UpdateLeaderMember()
    if self.domainCrewInBound.leaderId == PlayerSettingData.playerId then
        self.config.buttonLeave.transform.parent.gameObject:SetActive(false)
        self.config.buttonStart.transform.parent.gameObject:SetActive(true)
    else
        self.config.buttonLeave.transform.parent.gameObject:SetActive(true)
        self.config.buttonStart.transform.parent.gameObject:SetActive(false)

        if self.domainInBound:IsReady() == true then
            self.config.buttonUnReady.gameObject:SetActive(true)
            self.config.buttonReady.gameObject:SetActive(false)
        else
            self.config.buttonUnReady.gameObject:SetActive(false)
            self.config.buttonReady.gameObject:SetActive(true)
        end

        self.config.buttonLeave.gameObject:SetActive(not self.domainInBound:IsReady())
    end
end

function UIDomainTeamView:OnClickLeave()
    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("noti_leave"), nil, function()
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)

        end
        local callbackSuccess = function()
            self.domainInBound.isInCrew = false
            PopupMgr.ShowAndHidePopup(UIPopupName.UILobbyDomain, nil, UIPopupName.UIDomainTeam)
        end
        local callbackFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if logicCode ~= LogicCode.DOMAINS_CREW_MEMBER_NOT_READY then
                DomainInBound.Validate(function()
                    self:OnReadyShow()
                end, true)
            end
        end
        NetworkUtils.RequestAndCallback(OpCode.DOMAINS_CREW_MEMBER_LEAVE, nil, callbackSuccess, callbackFailed, onBufferReading)
    end)
end

function UIDomainTeamView:OnClickReady(isReady)
    local timeLeft = self.domainInBound.lastTimeReadyChange ~= nil and self.domainInBound.lastTimeReadyChange + 10 - zg.timeMgr:GetServerTime() or 0
    if timeLeft > 0 then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(string.format("%s: %ss",
                LanguageUtils.LocalizeCommon("try_again_few_seconds"), timeLeft))
        return
    end

    local callbackSuccess = function()
        self.domainInBound:SetReady(isReady)

        self:OnReadyShow()

        if isReady then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("ready"))
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("unready"))
        end
    end
    local callbackFailed = function(logicCode)
        if logicCode == LogicCode.DOMAINS_CREW_READY_CHANGE_BLOCK_DURATION then
            SmartPoolUtils.ShowShortNotification(string.format("%s: %ss",
                    LanguageUtils.LocalizeCommon("try_again_few_seconds"), timeLeft))
        elseif logicCode == LogicCode.DOMAINS_CREW_MEMBER_NOT_ENOUGH then
            SmartPoolUtils.LogicCodeNotification(logicCode)
        else
            SmartPoolUtils.LogicCodeNotification(logicCode)
            DomainInBound.Validate(function()
                self:OnReadyShow()
            end, true)
        end
    end
    NetworkUtils.RequestAndCallback(OpCode.DOMAINS_CREW_MEMBER_READY_UPDATE, UnknownOutBound.CreateInstance(PutMethod.Bool, isReady), callbackSuccess, callbackFailed, nil)
end

function UIDomainTeamView:OnClickLeave()
    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("noti_leave"), nil, function()
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)

        end
        local callbackSuccess = function()
            self.domainInBound.isInCrew = false
            PopupMgr.ShowAndHidePopup(UIPopupName.UILobbyDomain, nil, UIPopupName.UIDomainTeam)
        end
        local callbackFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            DomainInBound.Validate(function()
                self:OnReadyShow()
            end, true)
        end
        NetworkUtils.RequestAndCallback(OpCode.DOMAINS_CREW_MEMBER_LEAVE, nil, callbackSuccess, callbackFailed, onBufferReading)
    end)
end

function UIDomainTeamView:OnClickDisband()
    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("noti_disband"), nil, function()
        local callbackSuccess = function()
            self.domainInBound.isInCrew = false
            PopupMgr.ShowAndHidePopup(UIPopupName.UILobbyDomain, nil, UIPopupName.UIDomainTeam)

            local domainData = zg.playerData.domainData
            domainData.listFriendSearchDomain = nil
            domainData.listGuildSearch = nil
            domainData.listVerifyDomain = nil
        end
        local callbackFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            DomainInBound.Validate(function()
                self:OnReadyShow()
            end, true)
        end
        NetworkUtils.RequestAndCallback(OpCode.DOMAINS_CREW_DELETE, nil, callbackSuccess, callbackFailed)
    end)
end

function UIDomainTeamView:OnClickInvite()
    self.domainInBound:GetListFriendSearch(function()
        PopupMgr.ShowPopup(UIPopupName.UIDomainMemberSearch)
    end)
end

function UIDomainTeamView:OnClickVerify()
    self.domainInBound:ValidateDomainApplication(function()
        local data = {}
        data.callbackRequestDomain = function()
            DomainInBound.Validate(function()
                self:OnReadyShow()
            end, true)
        end
        data.callbackClose = function()
            PopupMgr.HidePopup(UIPopupName.UIDomainMemberVerify)
            self:CheckNotificationApplication()
        end
        PopupMgr.ShowPopup(UIPopupName.UIDomainMemberVerify, data)
    end)
end

function UIDomainTeamView:OnClickStart()
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        self.domainInBound:OnSetContributeHeroes(buffer, true)
    end
    local callbackSuccess = function()
        self:GoToDefenseMapStage()
    end
    local callbackFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
        DomainInBound.Validate(function()
            self:OnReadyShow()
        end, true)
    end
    NetworkUtils.RequestAndCallback(OpCode.CREW_BATTLE_START, nil,
            callbackSuccess, callbackFailed, onBufferReading)
end

function UIDomainTeamView:ReturnPoolListClass()
    if self.listClass ~= nil then
        ---@param v HeroIconView
        for i, v in ipairs(self.listClass:GetItems()) do
            v:ReturnPool()
        end
        self.listClass:Clear()
    end
end

function UIDomainTeamView:Hide()
    UIBaseView.Hide(self)
    self.uiScroll:Hide()
    self:ReturnPoolListClass()

    if self.listenerChatMessage then
        self.listenerChatMessage:Unsubscribe()
        self.listenerChatMessage = nil
    end

    if self.listenerDomain then
        self.listenerDomain:Unsubscribe()
        self.listenerDomain = nil
    end

    self.domainTeamWorld:OnHide()
end

function UIDomainTeamView:OnClickChat()
    local show = function()
        PopupMgr.ShowPopup(UIPopupName.UIChat, ChatLayoutType.DOMAINS)
    end
    ChatData.OnValidateDomainChat(show)
end

function UIDomainTeamView:OnClickHelp()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("domains_team_up_info"))
end

function UIDomainTeamView:ShowTicket()
    self.config.textCurrency.text = 1
    self.config.iconCurrency.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.DOMAIN_CHALLENGE_STAMINA)
    self.config.iconCurrency:SetNativeSize()
end

function UIDomainTeamView:CheckNotificationChat()
    local chatData = zg.playerData:GetChatData()
    chatData.isNotifyDomainTeam = false
    --- @param chatChanel ChatChanel
    --- @param lastMessageChannelReceived number
    for chatChanel, lastMessageChannelReceived in pairs(chatData.lastMessageChannelReceivedDict:GetItems()) do
        if ChatData.IsMainMenuChat(chatChanel) == false
                and ChatData.IsBlockChatChannel(chatChanel) == false
                and lastMessageChannelReceived > UIChatModel.GetLastTimeReadChannel(chatChanel) then
            chatData.isNotifyDomainTeam = true
            break
        end
    end
    self.config.notifyChat:SetActive(chatData.isNotifyDomainTeam)

    if chatData.isNotifyDomainTeam ~= true then
        ChatRequest.SubscribeChat()
    end
end

function UIDomainTeamView:CheckNotificationApplication()
    local listApplication = zg.playerData.domainData.listVerifyDomain
    self.config.notifyApplication:SetActive(listApplication ~= nil and listApplication:Count() > 0)
end

--- @param data {serverNotificationType  : ServerNotificationType}
function UIDomainTeamView:DomainUpdated(data)
    local serverNotificationType = data.serverNotificationType
    if serverNotificationType == ServerNotificationType.DOMAINS_CREW_UPDATED then
        self:OnReadyShow()
    elseif serverNotificationType == ServerNotificationType.DOMAINS_CREW_DISBANDED then
        zg.audioMgr:PlaySfxUi(SfxUiType.DICE_END)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("crew_disbanded"))
        PopupMgr.ShowPopup(UIPopupName.UILobbyDomain, nil, UIPopupHideType.HIDE_ALL)
    elseif serverNotificationType == ServerNotificationType.DOMAINS_CREW_MEMBER_KICKED then
        zg.audioMgr:PlaySfxUi(SfxUiType.DICE_END)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("kicked_from_crew"))
        PopupMgr.ShowPopup(UIPopupName.UILobbyDomain, nil, UIPopupHideType.HIDE_ALL)
    elseif serverNotificationType == ServerNotificationType.DOMAINS_CREW_APPLICATION_UPDATED then
        PopupMgr.HidePopup(UIPopupName.UIDomainMemberVerify)
        self.config.notifyApplication:SetActive(true)
    elseif serverNotificationType == ServerNotificationType.DOMAINS_CREW_INVITATION_UPDATED then
        local domainData = zg.playerData.domainData
        domainData.listFriendSearchDomain = nil
        PopupMgr.HidePopup(UIPopupName.UIDomainMemberSearch)

        self:OnReadyShow()
    elseif serverNotificationType == ServerNotificationType.DOMAINS_CREW_CHALLENGE_START
            or serverNotificationType == ServerNotificationType.DOMAINS_CREW_CHALLENGE_UPDATED then
        self:GoToDefenseMapStage()
    end
end

function UIDomainTeamView:GoToDefenseMapStage()
    PopupMgr.ShowPopup(UIPopupName.UIDomainsStageMap, nil, UIPopupHideType.HIDE_ALL)
end

function UIDomainTeamView:CheckTeamValid()
    if self.domainInBound.isInCrew == false then
        self:OnClickBackOrClose()
        return false
    end
    return true
end

function UIDomainTeamView:ShowMemberWorldState()
    self.domainTeamWorld:OnShow()
    self.domainTeamWorld:ShowListMember(self.domainCrewInBound.listMember)
end

--- @param data DomainsCrewMember
function UIDomainTeamView:OnClickChangeTeam(data)
    if data.playerId ~= PlayerSettingData.playerId then
        return
    end
    if self.domainInBound:IsReady() and PlayerSettingData.playerId ~= self.domainInBound.domainCrewInBound.leaderId then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("require_unready"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        return
    end
    local data = {}
    data.callbackClose = function()
        PopupMgr.ShowAndHidePopup(self.model.uiName, nil, UIPopupName.UIFormationDomain)
    end
    data.callbackSave = function()
        DomainInBound.Validate(function ()
            PopupMgr.ShowAndHidePopup(self.model.uiName, nil, UIPopupName.UIFormationDomain)
        end, true)
    end
    PopupMgr.ShowAndHidePopup(UIPopupName.UIFormationDomain, data, self.model.uiName)
end