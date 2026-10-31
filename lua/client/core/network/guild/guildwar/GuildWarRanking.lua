--- @class GuildWarRanking
GuildWarRanking = Class(GuildWarRanking)

function GuildWarRanking:Ctor()
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildWarRanking:ReadBuffer(buffer)
    self.guildId = buffer:GetInt()
    self.serverId = buffer:GetShort()
    self.guildName = buffer:GetString()
    self.guildAvatar = buffer:GetInt()
    self.guildLevel = buffer:GetShort()
    self.guildScore = buffer:GetLong()
    self.createdTime = buffer:GetLong()
end

function GuildWarRanking.CreateByBuffer(buffer)
    local guildWarRanking = GuildWarRanking()
    guildWarRanking:ReadBuffer(buffer)
    return guildWarRanking
end