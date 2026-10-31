require "lua.client.scene.ui.common.UserChatBoxView"

--- @class GuestChatBoxView : UserChatBoxView
GuestChatBoxView = Class(GuestChatBoxView, UserChatBoxView)

--- @return void
function GuestChatBoxView:SetPrefabName()
    self.prefabName = 'guest_chat_box'
    self.uiPoolType = UIPoolType.GuestChatBoxView
end

return GuestChatBoxView

