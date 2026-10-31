--- @class ChatBoxView : UIPrefabView
ChatBoxView = Class(ChatBoxView, UIPrefabView)

--- @return void
function ChatBoxView:Ctor()
    ---@type string
    self.prefabName = nil
    ---@type UIPoolType
    self.uiPoolType = nil
    ---@type UIChatBoxConfig
    self.config = nil
    ---@type UserChatBoxView
    self.userChatBox = nil
    ---@type GuestChatBoxView
    self.guestChatBox = nil
    UIPrefabView.Ctor(self)
end

--- @return void
function ChatBoxView:SetPrefabName()
    self.prefabName = 'chat_box'
    self.uiPoolType = UIPoolType.ChatBoxView
end

--- @return void
--- @param transform UnityEngine_Transform
function ChatBoxView:SetConfig(transform)
    ---@type UIChatBoxConfig
    self.config = UIBaseConfig(transform)
end

--- @param message ChatMessageInBound
--- @return void
function ChatBoxView:SetData(message)
    if message.playerId == PlayerSettingData.playerId then
        self:ShowUserChatBox(message)
    else
        self:ShowGuestChatBox(message)
    end
end

--- @param message ChatMessageInBound
--- @return void
function ChatBoxView:ShowUserChatBox(message)
    self.userChatBox = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UserChatBoxView, self.config.transform)
    self.userChatBox:SetData(message)
end

--- @param message ChatMessageInBound
--- @return void
function ChatBoxView:ShowGuestChatBox(message)
    --- @type GuestChatBoxView
    self.guestChatBox = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.GuestChatBoxView, self.config.transform)
    self.guestChatBox:SetData(message)
end

--- @return void
function ChatBoxView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    if self.userChatBox ~= nil then
        self.userChatBox:ReturnPool()
        self.userChatBox = nil
    end
    if self.guestChatBox ~= nil then
        self.guestChatBox:ReturnPool()
        self.guestChatBox = nil
    end
end

return ChatBoxView

