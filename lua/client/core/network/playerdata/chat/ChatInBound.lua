require "lua.client.scene.ui.home.uiChat.UIChatModel"

--- @class ChatInBound
ChatInBound = Class(ChatInBound)

--- @param chatChanel ChatChanel
function ChatInBound:Ctor(chatChanel)
    self.chatChanel = chatChanel
end

--- @param buffer UnifiedNetwork_ByteBuf
function ChatInBound:ReadBuffer(buffer)
    ChatData.ReadChatMessageData(self.chatChanel, buffer)
    --- @type ChatData
    local chatData = zg.playerData:GetChatData()
    if chatData ~= nil then
        --- @type ChatMessageInBound
        local lastChatMessage = chatData:GetLastChatMessageByChannel(self.chatChanel)
        local timeCreated
        if lastChatMessage ~= nil then
            timeCreated = lastChatMessage.createdTimeInSeconds
        else
            timeCreated = UIChatModel.GetLastTimeReadChannel(self.chatChanel)
        end
        chatData:SetLastTimeReceivedMessageByChannel(self.chatChanel, timeCreated)
    end
end