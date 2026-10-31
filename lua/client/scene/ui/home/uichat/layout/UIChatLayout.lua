--- @class UIChatLayout
UIChatLayout = Class(UIChatLayout)

--- @param view UIChatView
function UIChatLayout:Ctor(view)
    --- @type UIChatView
    self.view = view
    --- @type UIChatConfig
    self.config = view.config
end

function UIChatLayout:OnShow()
    self:SetUpLayout()

    self:ShowChat()
end

function UIChatLayout:SetUpLayout()

end

function UIChatLayout:ShowChat()

end

function UIChatLayout:OnHide()
    if self.view.uiScroll ~= nil then
        self.view.uiScroll:Hide()
    end
    self.view:HideSetting()

    UIChatModel.SetLastTimeReadChannel(self.view.chatChannel, zg.timeMgr:GetServerTime())
    RxMgr.notificationUnreadChatMessage:Next()
    ChatRequest.SubscribeChat()
    self.view.chatData.receiveMessageCallback = nil
end

function UIChatLayout:ShowNotification()

end

function UIChatLayout:ShowSettingOption()

end

--- @param channel ChatChanel
--- @param message string
function UIChatLayout:OnSendMessageSuccess(channel, message)

end