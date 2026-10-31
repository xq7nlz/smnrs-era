--- @class GuildDailyBossRewardConfig
GuildDailyBossRewardConfig = Class(GuildDailyBossRewardConfig)

function GuildDailyBossRewardConfig:Ctor()
    --- @type Dictionary --<tier, {min_damage, max_damage, number_random_reward}>
    self._rewardTierConfig = nil
    --- @type Dictionary --<tier, List<{res_type, res_id, res_number, res_data}>>
    self._randomRewardConfig = nil
    --- @type Dictionary --<tier, List<{res_type, res_id, res_number, res_data}>>
    self._fixedRewardConfig = nil
end

function GuildDailyBossRewardConfig:_InitRewardTierConfig()
    self._rewardTierConfig = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_DAILY_REWARD_TIER_PATH)
    for i = 1, #parsedData do
        local tier = tonumber(parsedData[i].tier)
        --- @type {min_damage, max_damage, number_random_reward}
        local tierData = {}
        tierData.min_damage = tonumber(parsedData[i].min_damage)
        tierData.max_damage = tonumber(parsedData[i].max_damage)
        tierData.number_random_reward = tonumber(parsedData[i].number_random_reward)

        self._rewardTierConfig:Add(tier, tierData)
    end
end

function GuildDailyBossRewardConfig:_InitRandomRewardConfig()
    self._randomRewardConfig = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_DAILY_RANDOM_REWARD_PATH)
    local currentTier
    for i = 1, #parsedData do
        local tier = tonumber(parsedData[i].tier)
        local listRandomRewards
        if MathUtils.IsNumber(tier) == true then
            listRandomRewards = List()
            self._randomRewardConfig:Add(tier, listRandomRewards)
            currentTier = tier
        end
        if self._randomRewardConfig:IsContainKey(currentTier) == true then
            listRandomRewards = self._randomRewardConfig:Get(currentTier)
        else
            listRandomRewards = List()
        end
        --- @type {res_type, res_id, res_number, res_data}
        local tierData = {}
        tierData.res_type = tonumber(parsedData[i].res_type)
        tierData.res_id = tonumber(parsedData[i].res_id)
        tierData.res_number = tonumber(parsedData[i].res_number)
        tierData.res_data = tonumber(parsedData[i].res_data)
        listRandomRewards:Add(tierData)

        self._randomRewardConfig:Add(currentTier, listRandomRewards)
    end
end

function GuildDailyBossRewardConfig:_InitFixedRewardConfig()
    self._fixedRewardConfig = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_DAILY_FIXED_REWARD_PATH)
    local currentTier
    for i = 1, #parsedData do
        local tier = tonumber(parsedData[i].tier)
        local listFixedRewards
        if MathUtils.IsNumber(tier) == true then
            listFixedRewards = List()
            self._fixedRewardConfig:Add(tier, listFixedRewards)
            currentTier = tier
        end
        if self._fixedRewardConfig:IsContainKey(currentTier) == true then
            listFixedRewards = self._fixedRewardConfig:Get(currentTier)
        else
            listFixedRewards = List()
        end
        --- @type {res_type, res_id, res_number, res_data}
        local tierData = {}
        tierData.res_type = tonumber(parsedData[i].res_type)
        tierData.res_id = tonumber(parsedData[i].res_id)
        tierData.res_number = tonumber(parsedData[i].res_number)
        tierData.res_data = tonumber(parsedData[i].res_data)
        listFixedRewards:Add(tierData)

        self._fixedRewardConfig:Add(currentTier, listFixedRewards)
    end
end

--- @return {min_damage, max_damage, number_random_reward}
--- @param tier number
function GuildDailyBossRewardConfig:GetRewardTierConfigByTier(tier)
    if self._rewardTierConfig == nil then
        self:_InitRewardTierConfig()
    end
    return  self._rewardTierConfig:Get(tier)
end

--- @return number
function GuildDailyBossRewardConfig:GetMilestoneCount()
    if self._rewardTierConfig == nil then
        self:_InitRewardTierConfig()
    end
    return self._rewardTierConfig:Count()
end

--- @return List, {res_type, res_id, res_number, res_data}
--- @param tier
function GuildDailyBossRewardConfig:GetListFixedRewardByTier(tier)
    if self._fixedRewardConfig == nil then
        self:_InitFixedRewardConfig()
    end
    return self._fixedRewardConfig:Get(tier)
end

--- @return List, {res_type, res_id, res_number, res_data}
--- @param tier
function GuildDailyBossRewardConfig:GetListRandomRewardByTier(tier)
    if self._randomRewardConfig == nil then
        self:_InitRandomRewardConfig()
    end
    return self._randomRewardConfig:Get(tier)
end