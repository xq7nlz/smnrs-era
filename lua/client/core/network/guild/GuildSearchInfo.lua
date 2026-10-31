--- @class GuildSearchInfo
GuildSearchInfo = Class(GuildSearchInfo)

--- @param buffer UnifiedNetwork_ByteBuf
function GuildSearchInfo:Ctor(buffer)
    --- @type number
    self.guildId = buffer:GetInt()
    --- @type string
    self.guildName = buffer:GetString()
    --- @type string
    self.guildDescription = buffer:GetString()
    --- @type number
    self.guildAvatar = buffer:GetInt()
    --- @type number
    self.guildLevel = buffer:GetByte()
    --- @type number
    self.sizeOfGuildMember = buffer:GetByte()
end