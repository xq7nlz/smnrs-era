--- @class UIChatDomainsLayout : UIChatLayout
UIChatDomainsLayout = Class(UIChatDomainsLayout, UIChatLayout)

function UIChatDomainsLayout:SetUpLayout()
    self.config.domainsTeamTab.gameObject:SetActive(true)
end

function UIChatDomainsLayout:ShowChat()
    self.view:OnShowChatChannel(ChatChanel.DOMAINS_TEAM)
    ---@param message ChatMessageInBound
    self.view.chatData.receiveMessageCallback = function(message)
        self.view:OnReceiveServerMessage(message)
    end
    ChatRequest.SubscribeChat()
end

function UIChatDomainsLayout:ShowNotification()
    self.view.chatData:CheckNotificationDomains()

    self.view:EnableChannelNotify(ChatChanel.DOMAINS_TEAM, self.view.chatData.isNotifyDomainTeam)
end

function UIChatDomainsLayout:ShowSettingOption()
    self.config.blockOptAnchor:GetChild(ChatChanel.DOMAINS_TEAM - 1).gameObject:SetActive(true)

    self.config.domainsTeamTick:SetActive(PlayerSettingData.isBlockDomainsTeamChat)
end

--- @param channel ChatChanel
--- @param message string
function UIChatDomainsLayout:OnSendMessageSuccess(channel, message)

end