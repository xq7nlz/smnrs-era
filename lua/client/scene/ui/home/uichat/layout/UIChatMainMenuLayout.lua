--- @class UIChatMainMenuLayout : UIChatLayout
UIChatMainMenuLayout = Class(UIChatMainMenuLayout, UIChatLayout)

function UIChatMainMenuLayout:SetUpLayout()
    self.config.buttonWorldTab.gameObject:SetActive(true)
    self.config.buttonGuildTab.gameObject:SetActive(true)
    self.config.buttonRecruitTab.gameObject:SetActive(true)
    self.config.domainsRecruitTab.gameObject:SetActive(true)
end

function UIChatMainMenuLayout:ShowChat()
    self.view:OnShowChatChannel(ChatChanel.WORLD)
    ---@param message ChatMessageInBound
    self.view.chatData.receiveMessageCallback = function(message)
        self.view:OnReceiveServerMessage(message)
    end
    ChatRequest.SubscribeChat()
end

function UIChatMainMenuLayout:ShowNotification()
    self.view.chatData:CheckNotificationMainMenu()

    self.view:EnableChannelNotify(ChatChanel.WORLD, self.view.chatData.isNotifyWorld)
    self.view:EnableChannelNotify(ChatChanel.GUILD, self.view.chatData.isNotifyGuild)
    self.view:EnableChannelNotify(ChatChanel.RECRUIT, self.view.chatData.isNotifyRecruit)
    self.view:EnableChannelNotify(ChatChanel.DOMAINS_RECRUIT, self.view.chatData.isNotifyDomainRecruit)

    --if UIChatView.callNotifyChatMainArea then
    --    UIChatView.callNotifyChatMainArea(self.view.chatData.isHasNotifyMainMenu)
    --end
end

function UIChatMainMenuLayout:ShowSettingOption()
    self.config.blockOptAnchor:GetChild(ChatChanel.WORLD).gameObject:SetActive(true)
    self.config.blockOptAnchor:GetChild(ChatChanel.GUILD).gameObject:SetActive(true)
    self.config.blockOptAnchor:GetChild(ChatChanel.RECRUIT).gameObject:SetActive(true)
    self.config.blockOptAnchor:GetChild(ChatChanel.DOMAINS_RECRUIT - 1).gameObject:SetActive(true)

    self.config.worldTick:SetActive(PlayerSettingData.isBlockWorldChat)
    self.config.guildTick:SetActive(PlayerSettingData.isBlockGuildChat)
    self.config.recruitTick:SetActive(PlayerSettingData.isBlockRecruitChat)
    self.config.domainsRecruitTick:SetActive(PlayerSettingData.isBlockDomainsRecruitChat)
end