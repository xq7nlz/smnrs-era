require "lua.client.core.network.guild.guildWar.GuildParticipant"

--- @class GuildWarPreviousBattleResultInBound
GuildWarPreviousBattleResultInBound = Class(GuildWarPreviousBattleResultInBound)

function GuildWarPreviousBattleResultInBound:Ctor()
    --- @type number
    self.rank = nil
    --- @type boolean
    self.isWin = nil
    --- @type boolean
    self.isParticipant = nil
    --- @type number
    self.battleId = nil
    --- @type GuildParticipant
    self.guildParticipant1 = nil
    --- @type GuildParticipant
    self.guildParticipant2 = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildWarPreviousBattleResultInBound:ReadBuffer(buffer)
    self.rank = buffer:GetInt()
    self.isWin = buffer:GetBool()
    self.isParticipant = buffer:GetBool()
    self.battleId = buffer:GetLong()
    self.guildParticipant1 = GuildParticipant.CreateByBuffer(buffer)
    self.guildParticipant2 = GuildParticipant.CreateByBuffer(buffer)
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildWarPreviousBattleResultInBound.CreateByBuffer(buffer)
    local guildWarPreviousBattleResultInBound = GuildWarPreviousBattleResultInBound()
    guildWarPreviousBattleResultInBound:ReadBuffer(buffer)
    return guildWarPreviousBattleResultInBound
end