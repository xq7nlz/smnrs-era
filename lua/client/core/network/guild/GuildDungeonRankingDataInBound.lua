require "lua.client.core.network.guild.GuildDungeonRankingInBound"

--- @class GuildDungeonRankingDataInBound
GuildDungeonRankingDataInBound = Class(GuildDungeonRankingDataInBound)

function GuildDungeonRankingDataInBound:Ctor()
    --- @type PlayerDataMethod
    self.rankingType = PlayerDataMethod.GUILD_DUNGEON_RANKING
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildDungeonRankingDataInBound:ReadBuffer(buffer)
    self.listOfGuildRankingOrder = NetworkUtils.GetListDataInBound(buffer, GuildDungeonRankingInBound)
    self.listOfGuildRankingOrder:Sort(self, GuildDungeonRankingDataInBound.SortListRanking)

    local sizeOfGuildRankingList = self.listOfGuildRankingOrder:Count()

    --- @type number
    self.guildDungeonRankingOrder = nil
    --- @type number
    self.guildDungeonRankingScore = nil

    if sizeOfGuildRankingList > 0 and self.rankingType == PlayerDataMethod.GUILD_DUNGEON_RANKING then
        --- @type number
        self.guildDungeonRankingOrder = buffer:GetInt()
        --- @type number
        self.guildDungeonRankingScore = buffer:GetLong()
    end
    --- @type number
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end

function GuildDungeonRankingDataInBound:IsAvailableToRequest()
    return self.lastTimeRequest == nil or (zg.timeMgr:GetServerTime() - self.lastTimeRequest) > TimeUtils.SecondAMin * 5
end

--- @return boolean
function GuildDungeonRankingDataInBound.NeedRequest()
    --- @type GuildDungeonRankingDataInBound
    local guildDungeonRankingDataInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_DUNGEON_RANKING)
    return guildDungeonRankingDataInBound == nil or guildDungeonRankingDataInBound:IsAvailableToRequest()
end

function GuildDungeonRankingDataInBound.RequestData(callback)
    if GuildDungeonRankingDataInBound.NeedRequest() then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.GUILD_DUNGEON_RANKING }, callback)
    else
        callback()
    end
end

--- @param x GuildDungeonRankingInBound
--- @param y GuildDungeonRankingInBound
function GuildDungeonRankingDataInBound:SortListRanking(x, y)
    if x.score > y.score then
        return -1
    elseif x.score < y.score then
        return 1
    else
        if x.numberClearedStages > y.numberAttack then
            return -1
        elseif x.numberClearedStages < y.numberAttack then
            return -1
        else
            if x.createdTimeInSec < y.createdTimeInSec then
                return -1
            end
            return 1
        end
    end
end

--- @class GuildDungeonHallOfFameRankingDataInBound
GuildDungeonHallOfFameRankingDataInBound = Class(GuildDungeonHallOfFameRankingDataInBound, GuildDungeonRankingDataInBound)

function GuildDungeonHallOfFameRankingDataInBound:Ctor()
    GuildDungeonRankingDataInBound.Ctor(self)
    self.rankingType = PlayerDataMethod.GUILD_DUNGEON_HALL_OF_FAME
end