require "lua.client.core.network.playerData.chat.messageInBound.MessageInBound"
require "lua.client.core.network.playerData.chat.messageInBound.RecruitMessageInBound"
require "lua.client.core.network.playerData.chat.messageInBound.MaintenanceMessageInBound"
require "lua.client.core.network.playerData.chat.messageInBound.DomainRecruitMessageInBound"

--- @class ChatMessageInBound
ChatMessageInBound = Class(ChatMessageInBound)

--- @return ChatMessageInBound
function ChatMessageInBound:Ctor()
    --- @type number
    self.serverId = nil
    --- @type number
    self.playerId = nil
    --- @type string
    self.playerName = nil
    --- @type number
    self.playerAvatar = nil
    --- @type string
    self.playerLevel = nil
    --- @type MessageInBound
    self.messageInBound = nil
    --- @type ChatChanel
    self.chatChannel = nil
    --- @type ChatMessageType
    self.chatMessageType = nil
    --- @type number
    self.idOfGuild = nil
    --- @type number
    self.createdTimeInSeconds = nil
    --- @type number
    self.startActiveTime = nil
    --- @type number
    self.endActiveTime = nil
    ---@type AvatarData
    self.avatarData = nil

end

--- @param buffer UnifiedNetwork_ByteBuf
--- @return List
function ChatMessageInBound.GetChatMessageInBoundList(buffer)
    --- @type BlockPlayerInBound
    local blockPlayerInBound = zg.playerData:GetMethod(PlayerDataMethod.BLOCKED_PLAYER_LIST)
    ---@type number
    local size = buffer:GetByte()
    ---@type List
    local listItem = List()
    for _ = 1, size do
        local chatMessageInBound = ChatMessageInBound.CreateByBuffer(buffer)
        local playerId = chatMessageInBound.playerId
        if blockPlayerInBound:IsBlock(playerId) == false then
            listItem:Add(chatMessageInBound)
        end
    end
    return listItem
end

--- @param buffer UnifiedNetwork_ByteBuf
function ChatMessageInBound.CreateByBuffer(buffer)
    local data = ChatMessageInBound()
    data.serverId = buffer:GetShort()
    data.playerId = buffer:GetLong()
    data.playerName = buffer:GetString()
    data.playerAvatar = buffer:GetInt()
    data.playerLevel = buffer:GetShort()
    local message = buffer:GetString(false)
    data.chatChannel = buffer:GetByte()
    data.chatMessageType = buffer:GetByte()
    data.messageInBound = ChatMessageInBound.CreateMessageInBoundByType(data.chatMessageType)
    if data.chatMessageType == ChatMessageType.GUILD_RECRUIT
            or data.chatMessageType == ChatMessageType.MAINTENANCE_MESSAGE
            or data.chatMessageType == ChatMessageType.DOMAIN_CREW_RECRUIT then
        data.messageInBound:CreateByJson(json.decode(message))
    else
        data.messageInBound:CreateByString(message)
    end
    data.idOfGuild = buffer:GetInt()
    data.idOfCrew = buffer:GetInt()
    data.createdTimeInSeconds = buffer:GetLong()
    if data.chatChannel == ChatChanel.SYSTEM then
        data.startActiveTime = buffer:GetLong()
        data.endActiveTime = buffer:GetLong()
    end
    data.avatarData = AvatarData(buffer)
    return data
end

--- @return string
function ChatMessageInBound:GetName()
    if self.playerId == PlayerSettingData.playerId then
        return zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).name
    else
        return self.playerName
    end
end

--- @return number
function ChatMessageInBound:GetAvatar()
    if self.playerId == PlayerSettingData.playerId then
        ---@type BasicInfoInBound
        local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
        return basicInfoInBound.avatarData:GetMyPlayerAvatar()
    else
        return self.avatarData:GetOtherPlayerAvatar()
        --return self.playerAvatar
    end
end

--- @return number
function ChatMessageInBound:GetLevel()
    if self.playerId == PlayerSettingData.playerId then
        return zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level
    else
        return self.playerLevel
    end
end

--- @param key string
function ChatMessageInBound:UpdateInfoByKey(key, newValue)
    if key == "name" then
        self.playerName = newValue
    elseif key == "avatar" then
        self.playerAvatar = newValue
    elseif key == "level" then
        self.playerLevel = newValue
    else
        XDebug.Error("SingleArenaRanking:UpdateInfoByKey Not Fount Key " .. key)
    end
end

--- @return MessageInBound
--- @param type ChatMessageType
function ChatMessageInBound.CreateMessageInBoundByType(type)
    if type == ChatMessageType.PLAIN_TEXT then
        return MessageInBound()
    elseif type == ChatMessageType.GUILD_RECRUIT then
        return RecruitMessageInBound()
    elseif type == ChatMessageType.MAINTENANCE_MESSAGE then
        return MaintenanceMessageInBound()
    elseif type == ChatMessageType.DOMAIN_CREW_RECRUIT then
        return DomainRecruitMessageInBound()
    else
        return MessageInBound()
    end
end