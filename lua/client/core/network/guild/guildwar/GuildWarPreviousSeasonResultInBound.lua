--- @class GuildWarPreviousSeasonResultInBound
GuildWarPreviousSeasonResultInBound = Class(GuildWarPreviousSeasonResultInBound)

function GuildWarPreviousSeasonResultInBound:Ctor()
    --- @type number
    self.rankingOder = nil
    --- @type number
    self.elo = nil
    --- @type number
    self.season = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildWarPreviousSeasonResultInBound:ReadBuffer(buffer)
    self.rankingOder = buffer:GetInt()
    self.elo = buffer:GetInt()
    self.season = buffer:GetLong()
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildWarPreviousSeasonResultInBound.CreateByBuffer(buffer)
    local guildWarPreviousSeasonResultInBound = GuildWarPreviousSeasonResultInBound()
    guildWarPreviousSeasonResultInBound:ReadBuffer(buffer)
    return guildWarPreviousSeasonResultInBound
end