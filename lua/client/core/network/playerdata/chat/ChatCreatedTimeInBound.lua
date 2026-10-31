--- @class ChatCreatedTimeInBound
ChatCreatedTimeInBound = Class(ChatCreatedTimeInBound)

function ChatCreatedTimeInBound:Ctor()

end

--- @param buffer UnifiedNetwork_ByteBuf
function ChatCreatedTimeInBound:ReadBuffer(buffer)
    local chatData = zg.playerData:GetChatData()
    chatData:SetLastTimeReceivedMessageByChannel(ChatChanel.WORLD, buffer:GetLong())
    chatData:SetLastTimeReceivedMessageByChannel(ChatChanel.GUILD, buffer:GetLong())
    chatData:SetLastTimeReceivedMessageByChannel(ChatChanel.RECRUIT, buffer:GetLong())
    chatData:SetLastTimeReceivedMessageByChannel(ChatChanel.SYSTEM, buffer:GetLong())
    chatData:SetLastTimeReceivedMessageByChannel(ChatChanel.DOMAINS_TEAM, buffer:GetLong())
    chatData:SetLastTimeReceivedMessageByChannel(ChatChanel.DOMAINS_RECRUIT, buffer:GetLong())
end