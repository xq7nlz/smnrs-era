require "lua.client.core.network.guild.guildWar.GuildWarRanking"

--- @class GuildWarRankingInBound
GuildWarRankingInBound = Class(GuildWarRankingInBound)

function GuildWarRankingInBound:Ctor()
    --- @type List
    self.listGuildWarRanking = nil
    --- @type number
    self.lastTimeRequest = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildWarRankingInBound:ReadBuffer(buffer)
    self.listGuildWarRanking = NetworkUtils.GetListDataInBound(buffer, GuildWarRanking.CreateByBuffer)
    if self.listGuildWarRanking:Count() > 0 then
        self.guildWarRankingOrder = buffer:GetInt()
        self.guildWarRankingScore = buffer:GetLong()
    end
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end

function GuildWarRankingInBound:IsAvailableToRequest()
    return self.lastTimeRequest == nil
            or zg.timeMgr:GetServerTime() - self.lastTimeRequest > 10
end

function GuildWarRankingInBound.NeedRequest()
    --- @type GuildWarRankingInBound
    local guildWarRankingInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR_RANKING)
    return guildWarRankingInBound == nil or guildWarRankingInBound:IsAvailableToRequest()
end

function GuildWarRankingInBound.Validate(callback)
    if GuildWarRankingInBound.NeedRequest() then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.GUILD_WAR_RANKING }, callback)
    else
        callback()
    end
end