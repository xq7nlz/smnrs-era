--- @class GuildDungeonDefenderTeamInBound
GuildDungeonDefenderTeamInBound = Class(GuildDungeonDefenderTeamInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function GuildDungeonDefenderTeamInBound:Ctor(buffer)
    --- @type PredefineTeamData
    self.predefineTeamData = PredefineTeamData.CreateByBuffer(buffer)
    --- @type List -- <HeroStateInBound>
    self.listHeroState = NetworkUtils.GetListDataInBound(buffer, HeroStateInBound.CreateByBuffer)
    --- @type List -- <GuildDungeonStatisticsInBound>
    self.listOfGuildDungeonStatistics = NetworkUtils.GetListDataInBound(buffer, GuildDungeonStatisticsInBound)
    --- @type number
    self.bossCreatedTime = buffer:GetLong()
    self:SortGuildDungeonStatistic()
    self.lastUpdated = zg.timeMgr:GetServerTime()
end

function GuildDungeonDefenderTeamInBound:NeedUpdate()
    return self.lastUpdated == nil or (zg.timeMgr:GetServerTime() - self.lastUpdated) > TimeUtils.SecondAMin / 2
end

--- @type number
function GuildDungeonDefenderTeamInBound:GetTotalDamageScore()
    local total = 0
    for i = 1, self.listOfGuildDungeonStatistics:Count() do
        --- @type GuildDungeonStatisticsInBound
        local guildDungeonStatisticsInBound = self.listOfGuildDungeonStatistics:Get(i)
        total = total + guildDungeonStatisticsInBound.playerScore
    end
    return total
end

function GuildDungeonDefenderTeamInBound:SortGuildDungeonStatistic()
    self.selfRanking = nil
    self.listOfGuildDungeonStatistics:Sort(self, self.SortItem)
    for i = 1, self.listOfGuildDungeonStatistics:Count() do
        --- @type GuildDungeonStatisticsInBound
        local statistics = self.listOfGuildDungeonStatistics:Get(i)
        if statistics.playerId == PlayerSettingData.playerId then
            self.selfRanking = i
            return
        end
    end
end

--- @return number
--- @param x GuildDungeonStatisticsInBound
--- @param y GuildDungeonStatisticsInBound
function GuildDungeonDefenderTeamInBound:SortItem(x, y)
    if x.playerScore > y.playerScore then
        return -1
    else
        return 1
    end
end