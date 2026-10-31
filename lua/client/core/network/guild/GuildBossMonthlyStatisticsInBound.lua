require "lua.client.core.network.guild.ItemGuildBossMonthlyStatisticsInBound"

--- @class GuildBossMonthlyStatisticsInBound
GuildBossMonthlyStatisticsInBound = Class(GuildBossMonthlyStatisticsInBound)

function GuildBossMonthlyStatisticsInBound:Ctor()
    --- @type number
    self.selfRankingOrder = nil
    --- @type number
    self.selfScore = nil
    --- @type List
    self.listOfStatistics = List()
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildBossMonthlyStatisticsInBound:ReadBuffer(buffer)
    --- @type List
    self.listOfStatistics = List()
    --- @type number
    local sizeOfList = buffer:GetByte()
    for _ = 1, sizeOfList do
        local itemData = ItemGuildBossMonthlyStatisticsInBound(buffer)
        self.listOfStatistics:Add(itemData)
        if itemData.playerId == PlayerSettingData.playerId then
            self.selfScore = itemData.score
        end
    end
    self:SortRanking()
    --- @type number
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end

function GuildBossMonthlyStatisticsInBound:IsAvailableToRequest()
    local result = self.lastTimeRequest == nil
            or (zg.timeMgr:GetServerTime() - self.lastTimeRequest) > TimeUtils.SecondAMin
    return result
end

function GuildBossMonthlyStatisticsInBound:SortRanking()
    self.listOfStatistics:Sort(self, self.SortHeroMethod)
    for i = 1, self.listOfStatistics:Count() do
        --- @type ItemGuildBossMonthlyStatisticsInBound
        local statistics = self.listOfStatistics:Get(i)
        if statistics.playerId == PlayerSettingData.playerId then
            self.selfRankingOrder = i
            return
        end
    end
    self.selfRankingOrder = nil
end

--- @return number
--- @param x ItemGuildBossMonthlyStatisticsInBound
--- @param y ItemGuildBossMonthlyStatisticsInBound
function GuildBossMonthlyStatisticsInBound:SortHeroMethod(x, y)
    if x.score > y.score then
        return -1
    elseif x.score < y.score then
        return 1
    else
        if x.updatedTime > y.updatedTime then
            return -1
        else
            return 1
        end
    end
end

function GuildBossMonthlyStatisticsInBound.RequestGuildMonthlyStatisticGet(onSuccess)
    local guildData = zg.playerData:GetGuildData()
    if guildData.guildBossMonthlyStatisticsData == nil
            or guildData.guildBossMonthlyStatisticsData:IsAvailableToRequest() == true then
        local onReceived = function(result)
            local guildData = zg.playerData:GetGuildData()
            guildData.guildBossMonthlyStatisticsData = GuildBossMonthlyStatisticsInBound()
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                guildData.guildBossMonthlyStatisticsData:ReadBuffer(buffer)
            end
            local onFailed = function(logicCode)
                if logicCode == LogicCode.GUILD_BOSS_MONTHLY_STATISTICS_NOT_FOUND then
                    onSuccess()
                else
                    SmartPoolUtils.LogicCodeNotification(logicCode)
                end
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.GUILD_BOSS_MONTHLY_STATISTICS_GET, UnknownOutBound.CreateInstance(PutMethod.Long, zg.timeMgr:GetServerTime()), onReceived)
    else
        onSuccess()
    end
end