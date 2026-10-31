require "lua.client.data.Guild.Boss.MonthlyReward.GuildMonthlyRewardTierConfig"

--- @class GuildMonthlyBossRewardConfig
GuildMonthlyBossRewardConfig = Class(GuildMonthlyBossRewardConfig)

function GuildMonthlyBossRewardConfig:Ctor()
    --- @type List GuildMonthlyRewardTierConfig
    self._listRewardTierConfig = nil

    --- @type Dictionary -- <rewardTier, List({RankingRewardByRangeConfig})>
    self._rewardSubTierConfigDict = nil

    self:_InitRewardTierConfig()
    self:_InitSubRewardTierConfig()
end

function GuildMonthlyBossRewardConfig:_InitRewardTierConfig()
    self._listRewardTierConfig = List()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(string.format(CsvPathConstants.GUILD_MONTHLY_REWARD_TIER_PATH))
    for i = 1, #parsedData do
        --- @type GuildMonthlyRewardTierConfig
        local guildMonthlyRewardTierConfig = GuildMonthlyRewardTierConfig()
        local line = parsedData[i]
        guildMonthlyRewardTierConfig.tier = tonumber(line.tier)
        guildMonthlyRewardTierConfig.minGuildLevel = tonumber(line.min_guild_level)
        guildMonthlyRewardTierConfig.maxGuildLevel = tonumber(line.max_guild_level)
        guildMonthlyRewardTierConfig.minDamageToGainReward = tonumber(line.min_damage_to_receive_reward)
        self._listRewardTierConfig:Add(guildMonthlyRewardTierConfig)
    end
end

function GuildMonthlyBossRewardConfig:_InitSubRewardTierConfig()
    self._rewardSubTierConfigDict = Dictionary()
    local parsedData
    for i = 1, self._listRewardTierConfig:Count() do
        parsedData = CsvReaderUtils.ReadAndParseLocalFile(string.format(CsvPathConstants.GUILD_MONTHLY_REWARD_FORMAT, i))
        local currentIndexListSub
        local listSubRewardByRewardTier = List()
        for j = 1, #parsedData do
            local min_rank = tonumber(parsedData[j].min_rank)
            local max_rank = tonumber(parsedData[j].max_rank)
            --- @type RankingRewardByRangeConfig
            local currentRankingRewardByRangeConfig
            if MathUtils.IsNumber(min_rank) == true and MathUtils.IsNumber(max_rank) == true then
                currentRankingRewardByRangeConfig = RankingRewardByRangeConfig(min_rank, max_rank)
                listSubRewardByRewardTier:Add(currentRankingRewardByRangeConfig)
                if j == 1 then
                    currentIndexListSub = 1
                else
                    currentIndexListSub = currentIndexListSub + 1
                end
            else
                currentRankingRewardByRangeConfig = listSubRewardByRewardTier:Get(currentIndexListSub)
            end
            local data = parsedData[j]
                currentRankingRewardByRangeConfig:AddRewardToList(RewardInBound.CreateByParams(data))
        end
        self._rewardSubTierConfigDict:Add(i, listSubRewardByRewardTier)
    end
end

--- @return GuildMonthlyRewardTierConfig
--- @param guildLevel number
function GuildMonthlyBossRewardConfig:GetRewardTierConfigByGuildLevel(guildLevel)
    for i = 1, self._listRewardTierConfig:Count() do
        --- @type GuildMonthlyRewardTierConfig
        local rewardTierConfig = self._listRewardTierConfig:Get(i)
        if guildLevel >= rewardTierConfig.minGuildLevel and guildLevel <= rewardTierConfig.maxGuildLevel then
            return rewardTierConfig
        end
    end
    return self._listRewardTierConfig:Get(self._listRewardTierConfig:Count())
end

--- @return List | RankingRewardByRangeConfig
--- @param rewardTier number
function GuildMonthlyBossRewardConfig:GetListSubRewardByRewardTier(rewardTier)
    return self._rewardSubTierConfigDict:Get(rewardTier)
end

--- @return List
--- @param bossTier number
--- @param rewardTier number
function GuildMonthlyBossRewardConfig:GetListReward(rewardTier, rank)
    local listSubRewardByTierConfig = self:GetListSubRewardByRewardTier(rewardTier)
    for i = 1, listSubRewardByTierConfig:Count() do
        --- @type RankingRewardByRangeConfig
        local rankingRewardByRangeConfig = listSubRewardByTierConfig:Get(i)
        if rankingRewardByRangeConfig:IsFitRank(rank) then
            return rankingRewardByRangeConfig.listRewardConfig
        end
    end
    return listSubRewardByTierConfig:Get(listSubRewardByTierConfig:Count()).listRewardConfig
end