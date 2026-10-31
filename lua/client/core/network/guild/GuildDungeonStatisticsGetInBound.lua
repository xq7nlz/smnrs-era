--- @class GuildDungeonStatisticsGetInBound
GuildDungeonStatisticsGetInBound = Class(GuildDungeonStatisticsGetInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function GuildDungeonStatisticsGetInBound:Ctor(buffer)
    --- @type List
    self.listGuildDungeonStatistics = NetworkUtils.GetListDataInBound(buffer, GuildDungeonStatisticsInBound)
    --- @type number
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
    --- @type number
    self.selfRank = nil
    self:SortRanking()
end

--- @return boolean
function GuildDungeonStatisticsGetInBound:IsAvailableToRequest()
    return self.lastTimeRequest == nil or (zg.timeMgr:GetServerTime() - self.lastTimeRequest) > TimeUtils.SecondAMin
end

--- @param key string
function GuildDungeonStatisticsGetInBound:UpdateInfoByKey(key, newValue)
    for i = 1, self.listGuildDungeonStatistics:Count() do
        --- @type GuildDungeonStatisticsInBound
        local statistics = self.listGuildDungeonStatistics:Get(i)
        if statistics.playerId == PlayerSettingData.playerId then
            statistics:UpdateInfoByKey(key, newValue)
            break
        end
    end
end

function GuildDungeonStatisticsGetInBound:SortRanking()
    self.listGuildDungeonStatistics:Sort(self, self.SortHeroMethod)
    for i = 1, self.listGuildDungeonStatistics:Count() do
        --- @type GuildDungeonStatisticsInBound
        local statistics = self.listGuildDungeonStatistics:Get(i)
        if statistics.playerId == PlayerSettingData.playerId then
            self.selfRank = i
            return
        end
    end
    self.selfRank = nil
end

--- @return number
--- @param x GuildDungeonStatisticsInBound
--- @param y GuildDungeonStatisticsInBound
function GuildDungeonStatisticsGetInBound:SortHeroMethod(x, y)
    if x.playerScore > y.playerScore then
        return -1
    elseif x.playerScore < y.playerScore then
        return 1
    else
        if x.numberAttack > y.numberAttack then
            return -1
        else
            return 1
        end
    end
end

function GuildDungeonStatisticsGetInBound.RequestGuildDungeonStatisticGet(onSuccess, onFailed)
    --- @type GuildData
    local guildData = zg.playerData:GetGuildData()
    if guildData.guildDungeonStatisticsGetInBound == nil
            or guildData.guildDungeonStatisticsGetInBound:IsAvailableToRequest() == true then
        local onReceived = function(result)
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                guildData.guildDungeonStatisticsGetInBound = GuildDungeonStatisticsGetInBound(buffer)
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.GUILD_DUNGEON_STATISTICS_GET, nil, onReceived)
    else
        onSuccess()
    end
end