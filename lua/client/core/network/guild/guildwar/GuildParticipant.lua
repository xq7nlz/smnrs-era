--- @class GuildParticipant
GuildParticipant = Class(GuildParticipant)

function GuildParticipant:Ctor()
    --- @type number
    self.guildId = nil
    --- @type string
    self.guildName = nil
    --- @type number
    self.guildAvatar = nil
    --- @type number
    self.elo = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildParticipant:ReadBuffer(buffer)
    self.guildId = buffer:GetInt()
    self.guildName = buffer:GetString()
    self.guildAvatar = buffer:GetInt()
    self.elo = buffer:GetInt()
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildParticipant.CreateByBuffer(buffer)
    local guildParticipant = GuildParticipant()
    guildParticipant:ReadBuffer(buffer)
    return guildParticipant
end