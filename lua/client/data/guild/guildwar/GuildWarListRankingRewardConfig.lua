--- @class GuildWarListRankingRewardConfig
GuildWarListRankingRewardConfig = Class(GuildWarListRankingRewardConfig)

function GuildWarListRankingRewardConfig:Ctor(csvPath)
    --- @type List
    self.listRangeRankingReward = nil
    self:_InitConfig(csvPath)
end

function GuildWarListRankingRewardConfig:_InitConfig(csvPath)
    self.listRangeRankingReward = List()
    local parseData = CsvReaderUtils.ReadAndParseLocalFile(csvPath)
    --- @type RankingRewardByRangeConfig
    local currentRankingRewardByRangeConfig
    local guildRole = nil
    for i = 1, #parseData do
        local minRanking = tonumber(parseData[i].min_ranking)
        local maxRanking = tonumber(parseData[i].max_ranking)
        if MathUtils.IsNumber(minRanking) == true and MathUtils.IsNumber(maxRanking) == true then
            currentRankingRewardByRangeConfig = RankingRewardByRangeConfig(minRanking, maxRanking)
            self.listRangeRankingReward:Add(currentRankingRewardByRangeConfig)
        end
        local data = parseData[i]
        if (data.guild_role ~= nil) then
            guildRole = tonumber(data.guild_role)
        end
        if (data ~= nil)  then
            currentRankingRewardByRangeConfig:AddRewardToList(RewardInBound.CreateByParams(data),guildRole)
        end
    end
end

--- @return RankingRewardByRangeConfig
--- @param ranking number
function GuildWarListRankingRewardConfig:GetRankingRewardByRangeConfig(ranking)
    for i = 1, self.listRangeRankingReward:Count() do
        --- @type RankingRewardByRangeConfig
        local rankingRewardByRangeConfig = self.listRangeRankingReward:Get(i)
        if rankingRewardByRangeConfig:IsFitRank(ranking) then
            return rankingRewardByRangeConfig
        end
    end
    XDebug.Error("Ranking Config not found " .. ranking)
end