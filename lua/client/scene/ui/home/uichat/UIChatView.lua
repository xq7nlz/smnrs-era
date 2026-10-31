require "lua.client.scene.ui.common.ChatBoxView"
require "lua.client.scene.ui.home.uiChat.layout.UIChatLayout"

--- @type UnityEngine_UI_LayoutRebuilder
local U_LayoutRebuilder = UnityEngine.UI.LayoutRebuilder
local utf8 = require("lua.client.utils.Utf8string")
local offsetHighlightPos = U_Vector3(12, -21.2, 0)

--- @class UIChatView : UIBaseView
UIChatView = Class(UIChatView, UIBaseView)
---@type function
UIChatView.callNotifyChatMainArea = nil
---@type function
UIChatView.callNotifyChatDomains = nil

--- @return void
--- @param model UIChatModel
function UIChatView:Ctor(model)
    --- @type UIChatConfig
    self.config = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type ChatChanel
    self.chatChannel = ChatChanel.WORLD
    --- @type number
    self.lastSend = os.time() - 1000
    --- @type ChatData
    self.chatData = nil
    --- @type Dictionary
    self.buttonTabConfigDict = Dictionary()

    --- @type UIChatLayout
    self.layout = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    UIBaseView.Ctor(self, model)
    --- @type UIChatModel
    self.model = model
end

--- @return void
function UIChatView:OnReadyCreate()
    ---@type UIChatConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:InitScrollView()

    self:InitButtonListener()

    self:InitButtonChatConfig()

    self.config.textMessage.characterLimit = ResourceMgr.GetChat().messageLength
end

function UIChatView:InitScrollView()
    --- @param obj ChatBoxView
    --- @param index number
    local onCreateItem = function(obj, index)
        local message = self.model.chatData:Get(index + 1)
        obj:SetData(message)
        U_LayoutRebuilder.ForceRebuildLayoutImmediate(self.config.chatBox)
    end
    self.uiScroll = UILoopScroll(self.config.scrollView, UIPoolType.ChatBoxView, onCreateItem)
end

function UIChatView:InitButtonListener()
    self.config.bgNone.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonSend.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:SendMessage()
    end)
    self.config.buttonSetting.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:ShowSetting()
    end)
    self.config.buttonHideSetting.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:HideSetting()
    end)
    self.config.toggleBlockWorldChat.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:ToggleBlockWorldChat()
    end)
    self.config.toggleBlockGuildChat.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:ToggleBlockGuildChat()
    end)
    self.config.toggleBlockRecruit.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:ToggleBlockRecruitChat()
    end)
    self.config.optDomainsTeam.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:ToggleBlockDomainsTeamChat()
    end)
    self.config.optDomainsRecruit.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:ToggleBlockDomainsRecruitChat()
    end)
end

function UIChatView:InitButtonChatConfig()
    --- @type ChatChanel
    for channel = 0, self.config.chatTab.childCount - 1 do
        --- @type UITabPopupConfig
        local uiTabPopupConfig = UIBaseConfig(self.config.chatTab:GetChild(channel))
        uiTabPopupConfig.button.onClick:AddListener(function()
            self:OnClickTab(channel)
        end)
        self.buttonTabConfigDict:Add(channel, uiTabPopupConfig)
    end
end

--- @return void
function UIChatView:InitLocalization()
    self.config.localizeOption2.text = LanguageUtils.LocalizeCommon("chat_option_2")
    self.config.localizeOption3.text = LanguageUtils.LocalizeCommon("chat_option_3")
    self.config.localizeOption4.text = LanguageUtils.LocalizeCommon("chat_option_4")
    self.config.localizeWorld.text = LanguageUtils.LocalizeCommon("world")
    self.config.localizeGuild.text = LanguageUtils.LocalizeFeature(FeatureType.GUILD)
    self.config.localizeRecruit.text = LanguageUtils.LocalizeCommon("recruit")
    self.config.localizeSend.text = LanguageUtils.LocalizeCommon("send")
    self.config.localizePlaceholder.text = LanguageUtils.LocalizeCommon("enter_chat")

    self.config.textOptDomainsTeam.text = LanguageUtils.LocalizeCommon("block_domains_team_chat")
    self.config.textOptDomainsRecruit.text = LanguageUtils.LocalizeCommon("block_domains_recruit_chat")

    self.config.localizeDomainsTeam.text = LanguageUtils.LocalizeCommon("domains_team")
    self.config.localizeDomainsRecruit.text = LanguageUtils.LocalizeCommon("domains_recruit")
end

--- @param chatLayoutType ChatLayoutType
function UIChatView:OnReadyShow(chatLayoutType)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.chatData = zg.playerData:GetChatData()

    self:GetLayout(chatLayoutType)
    self.layout:OnShow()
end

function UIChatView:GetLayout(layout)
    self:DisableCommon()

    self.layout = self.layoutDict:Get(layout)
    if self.layout == nil then
        if layout == ChatLayoutType.MAIN_MENU then
            require "lua.client.scene.ui.home.uiChat.layout.UIChatMainMenuLayout"
            self.layout = UIChatMainMenuLayout(self)
        else
            require "lua.client.scene.ui.home.uiChat.layout.UIChatDomainsLayout"
            self.layout = UIChatDomainsLayout(self)
        end
        self.layoutDict:Add(layout, self.layout)
    end
end

function UIChatView:DisableCommon()
    for i = 1, self.config.chatTab.childCount do
        local tab = self.config.chatTab:GetChild(i - 1)
        tab.gameObject:SetActive(false)
    end
end

function UIChatView:Hide()
    self.layout:OnHide()
    self.config.textMessage.text = ""
    UIBaseView.Hide(self)
end

---@return void
function UIChatView:ShowWorldChat()
    local chanel = ChatChanel.WORLD
    self:SetHighlightTabChannel(chanel)

    self:EnableChatBar(true)

    local showWorldChatData = function()
        self.model.chatData = self.chatData:GetChatMessageByChannel(chanel)
        self:UpdateGrid()
        UIChatModel.SetLastTimeReadChannel(chanel, zg.timeMgr:GetServerTime())
        self:OnSuccessShowChatData()
    end
    ChatRequest.ValidateChatChannel(chanel, showWorldChatData)
end

---@return void
function UIChatView:ShowGuildChat()
    local chanel = ChatChanel.GUILD

    local failToSelectTab = function()
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        self:OnShowChatChannel(ChatChanel.WORLD)
    end
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.GUILD, true) == false then
        failToSelectTab()
        return
    end
    self:SetHighlightTabChannel(chanel)
    local onCompleteGuildBasicInfo = function()
        local hasGuild = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO).isHaveGuild
        self:EnableChatBar(hasGuild)
        local showGuildChat = function()
            self.model.chatData = self.chatData:GetChatMessageByChannel(chanel)
            self:UpdateGrid()

            UIChatModel.SetLastTimeReadChannel(chanel, zg.timeMgr:GetServerTime())
            self:OnSuccessShowChatData()
        end
        if hasGuild then
            ChatRequest.ValidateChatChannel(chanel, showGuildChat)
        else
            SmartPoolUtils.LogicCodeNotification(LogicCode.GUILD_NOT_FOUND)
            failToSelectTab()
        end
    end
    GuildBasicInfoInBound.Validate(onCompleteGuildBasicInfo)
end

function UIChatView:ShowRecruitChat()
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.GUILD, true) == false then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        self:OnShowChatChannel(ChatChanel.WORLD)
        return
    end
    local chanel = ChatChanel.RECRUIT

    self:SetHighlightTabChannel(chanel)

    self:EnableChatBar(false)
    local showRecruitChat = function()
        self.model.chatData = self.chatData:GetChatMessageByChannel(chanel)
        self:UpdateGrid()

        UIChatModel.SetLastTimeReadChannel(chanel, zg.timeMgr:GetServerTime())
        self:OnSuccessShowChatData()
    end
    ChatRequest.ValidateChatChannel(chanel, showRecruitChat)
end

function UIChatView:ShowDomainTeamChat()
    local channel = ChatChanel.DOMAINS_TEAM
    self:SetHighlightTabChannel(channel)

    self:EnableChatBar(true)

    local showChatData = function()
        self.model.chatData = self.chatData:GetChatMessageByChannel(channel)
        self:UpdateGrid()
        UIChatModel.SetLastTimeReadChannel(channel, zg.timeMgr:GetServerTime())
        self:OnSuccessShowChatData()
    end
    ChatRequest.ValidateChatChannel(channel, showChatData)
end

function UIChatView:ShowDomainRecruitChat()
    local channel = ChatChanel.DOMAINS_RECRUIT

    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.DOMAINS, true) == false then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        self:OnShowChatChannel(ChatChanel.DOMAINS_TEAM)
        return
    end

    self:SetHighlightTabChannel(channel)

    self:EnableChatBar(false)
    local showChat = function()
        self.model.chatData = self.chatData:GetChatMessageByChannel(channel)
        self:UpdateGrid()

        UIChatModel.SetLastTimeReadChannel(channel, zg.timeMgr:GetServerTime())
        self:OnSuccessShowChatData()
    end
    ChatRequest.ValidateChatChannel(channel, showChat)
end

---@return void
function UIChatView:IEShowGridChat()
    Coroutine.start(function()
        coroutine.null()
        U_LayoutRebuilder.ForceRebuildLayoutImmediate(self.uiScroll.scroll.content)
    end)
end

function UIChatView:SendMessage()
    --- @type string
    local message = StringUtils.Trim(self.config.textMessage.text)
    if (message ~= nil and message ~= '') then
        --- @type number
        local delay = self.lastSend + ChatData.DELAY_SEND_MESSAGE - os.time()
        if delay > 0 then
            SmartPoolUtils.ShowShortNotification(string.format(LanguageUtils.LocalizeCommon("chat_delay"), delay))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        else
            self.lastSend = os.time()
            local uMessage = utf8(message)
            if #uMessage > ResourceMgr.GetChat().messageLength then
                uMessage = uMessage:sub(1, ResourceMgr.GetChat().messageLength)
            end

            --- @param message string
            local onSuccess = function(message)
                self:OnSendMessageSuccess(self.chatChannel, message)
            end
            if self.chatChannel < 0 then
                assert(false, "Wrong chanel with current tab " .. self.chatChannel)
            else
                ChatRequest.Send(tostring(uMessage), self.chatChannel, onSuccess)
            end
        end
    else
        self.config.textMessage.text = ""
    end
end

--- @param channel ChatChanel
--- @param message string
function UIChatView:OnSendMessageSuccess(channel, message)
    self.config.textMessage.text = ""
    self.layout:OnSendMessageSuccess(channel, message)
end

function UIChatView:UpdateGrid()
    ---@type number
    local count
    if self.model.chatData ~= nil then
        count = self.model.chatData:Count()
    else
        count = 0
    end
    self.uiScroll.scroll.totalCount = count
    self.uiScroll:RefillCells()
    self:IEShowGridChat()
end

function UIChatView:ShowSetting()
    for i = 0, self.config.blockOptAnchor.childCount - 1 do
        local opt = self.config.blockOptAnchor:GetChild(i)
        opt.gameObject:SetActive(false)
    end

    self.config.optChatPanel:SetActive(true)

    self.layout:ShowSettingOption()
end

function UIChatView:HideSetting()
    self.config.optChatPanel:SetActive(false)
end

function UIChatView:ToggleBlockWorldChat()
    PlayerSettingData.isBlockWorldChat = not PlayerSettingData.isBlockWorldChat
    PlayerSetting.SaveData()
    self.config.worldTick:SetActive(PlayerSettingData.isBlockWorldChat)
end

function UIChatView:ToggleBlockGuildChat()
    PlayerSettingData.isBlockGuildChat = not PlayerSettingData.isBlockGuildChat
    PlayerSetting.SaveData()
    self.config.guildTick:SetActive(PlayerSettingData.isBlockGuildChat)
end

function UIChatView:ToggleBlockRecruitChat()
    PlayerSettingData.isBlockRecruitChat = not PlayerSettingData.isBlockRecruitChat
    PlayerSetting.SaveData()
    self.config.recruitTick:SetActive(PlayerSettingData.isBlockRecruitChat)
end

function UIChatView:ToggleBlockDomainsTeamChat()
    PlayerSettingData.isBlockDomainsTeamChat = not PlayerSettingData.isBlockDomainsTeamChat
    PlayerSetting.SaveData()
    self.config.domainsTeamTick:SetActive(PlayerSettingData.isBlockDomainsTeamChat)
end

function UIChatView:ToggleBlockDomainsRecruitChat()
    PlayerSettingData.isBlockDomainsRecruitChat = not PlayerSettingData.isBlockDomainsRecruitChat
    PlayerSetting.SaveData()
    self.config.domainsRecruitTick:SetActive(PlayerSettingData.isBlockDomainsRecruitChat)
end

--- @param isEnable boolean
function UIChatView:EnableChatBar(isEnable)
    self.config.bottom:SetActive(isEnable)
end

---@return void
function UIChatView:ShowNoticeNewMessage()
    self.layout:ShowNotification()
end

--- @param message ChatMessageInBound
function UIChatView:OnReceiveServerMessage(message)
    if message.chatChannel == self.chatChannel then
        local time = zg.timeMgr:GetServerTime()
        self.chatData:SetLastTimeReceivedMessageByChannel(message.chatChannel, time)
        UIChatModel.SetLastTimeReadChannel(message.chatChannel, time)

        self:OnShowChatChannel(self.chatChannel)
    else
        self.chatData:SetLastTimeReceivedMessageByChannel(message.chatChannel, message.createdTimeInSeconds)
    end
end

--- @param channel ChatChanel
--- @param isEnable boolean
function UIChatView:EnableChannelNotify(channel, isEnable)
    isEnable = isEnable and not ChatData.IsBlockChatChannel(channel)
    --- @type UITabPopupConfig
    local tabChatConfig = self.buttonTabConfigDict:Get(channel)
    tabChatConfig.imageOn:SetActive(isEnable)
end

function UIChatView:OnSuccessShowChatData()
    self:ShowNoticeNewMessage()
end

--- @param channel ChatChanel
function UIChatView:SetHighlightTabChannel(channel)
    local tab = self.config.chatTab:GetChild(channel)

    self.config.highlightTab:SetParent(tab)
    self.config.highlightTab:SetAsFirstSibling()
    self.config.highlightTab.anchoredPosition3D = offsetHighlightPos
    self.config.highlightTab.localScale = U_Vector3.one
end

--- @param channel ChatChanel
function UIChatView:OnClickTab(channel)
    if channel == ChatChanel.GUILD or channel == ChatChanel.RECRUIT then
        local result = ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.GUILD, true)
        if result == false then
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            return
        end
    elseif channel == ChatChanel.DOMAINS_TEAM or channel == ChatChanel.DOMAINS_RECRUIT then
        local result = ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.DOMAINS, true)
        if result == false then
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            return
        end
    end
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    self:OnShowChatChannel(channel)
end

--- @param channel ChatChanel
function UIChatView:OnShowChatChannel(channel)
    self.chatChannel = channel
    if channel == ChatChanel.WORLD then
        self:ShowWorldChat()
    elseif channel == ChatChanel.GUILD then
        self:ShowGuildChat()
    elseif channel == ChatChanel.RECRUIT then
        self:ShowRecruitChat()
    elseif channel == ChatChanel.DOMAINS_TEAM then
        self:ShowDomainTeamChat()
    elseif channel == ChatChanel.DOMAINS_RECRUIT then
        self:ShowDomainRecruitChat()
    end
end