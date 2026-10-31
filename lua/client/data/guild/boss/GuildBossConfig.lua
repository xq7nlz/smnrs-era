require "lua.client.data.Guild.Boss.CommonGuildBossConfig"
require "lua.client.data.Guild.Boss.GuildBossDefenderTeam.GuildBossDefenderTeamConfig"
require "lua.client.data.Guild.Boss.DailyReward.GuildDailyBossRewardConfig"
require "lua.client.data.Guild.Boss.MonthlyReward.GuildMonthlyBossRewardConfig"

--- @class GuildBossConfig
GuildBossConfig = Class(GuildBossConfig)

function GuildBossConfig:Ctor()
    --- @type CommonGuildBossConfig
    self._commonBossConfig = nil
    --- @type GuildBossDefenderTeamConfig
    self._defenderTeamConfig = nil
    --- @type {level, boss_id}
    self._guildBossIdConfig = nil
    --- @type Dictionary -- {bossId, List}
    self._guildBossParticipateRewardConfig = nil

    --- @type GuildDailyBossRewardConfig
    self._guildDailyBossRewardConfig = nil
    --- @type GuildMonthlyBossRewardConfig
    self._guildMonthlyBossRewardConfig = nil
end

--- @return CommonGuildBossConfig
function GuildBossConfig:GetCommonGuildBossConfig()
    if self._commonBossConfig == nil then
        self._commonBossConfig = CommonGuildBossConfig()
    end
    return self._commonBossConfig
end

--- @return GuildBossDefenderTeamConfig
function GuildBossConfig:GetGuildBossDefenderTeamConfig()
    if self._defenderTeamConfig == nil then
        self._defenderTeamConfig = GuildBossDefenderTeamConfig()
    end
    return self._defenderTeamConfig
end

--- @return {level, boss_id}
function GuildBossConfig:GetGuildBossIdConfig()
    if self._guildBossIdConfig == nil then
        self:_InitGuildBossIdConfig()
    end
    return self._guildBossIdConfig
end

--- @return Dictionary -- {bossId, List}
function GuildBossConfig:GetGuildParticipateRewardConfig()
    if self._guildBossParticipateRewardConfig == nil then
        self:_InitGuildBossParticipateRewardConfig()
    end
    return self._guildBossParticipateRewardConfig
end

--- @return GuildDailyBossRewardConfig
function GuildBossConfig:GetGuildDailyBossRewardConfig()
    if self._guildDailyBossRewardConfig == nil then
        self._guildDailyBossRewardConfig = GuildDailyBossRewardConfig()
    end
    return self._guildDailyBossRewardConfig
end

--- @return GuildMonthlyBossRewardConfig
function GuildBossConfig:GetGuildMonthlyBossRewardConfig()
    if self._guildMonthlyBossRewardConfig == nil then
        self._guildMonthlyBossRewardConfig = GuildMonthlyBossRewardConfig()
    end
    return self._guildMonthlyBossRewardConfig
end

function GuildBossConfig:_InitGuildBossIdConfig()
    self._guildBossIdConfig = {}
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_BOSS_ID_CONFIG_PATH)
    for i = 1, #parsedData do
        local level = tonumber(parsedData[i].level)
        local bossId = tonumber(parsedData[i].boss_id)

        self._guildBossIdConfig[level] = bossId
    end
end

function GuildBossConfig:_InitGuildBossParticipateRewardConfig()
    self._guildBossParticipateRewardConfig = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_BOSS_PARTICIPATE_REWARD_PATH)
    local lastBossId
    for i = 1, #parsedData do
        local bossId = tonumber(parsedData[i].boss_id)
        if MathUtils.IsNumber(bossId) == true then
            lastBossId = bossId
            local newListReward = List()
            self._guildBossParticipateRewardConfig:Add(bossId, newListReward)
        end
        local listReward = self._guildBossParticipateRewardConfig:Get(lastBossId)
        listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
        self._guildBossParticipateRewardConfig:Add(lastBossId, listReward)
    end
end

--- @param guildLevel number
function GuildBossConfig:GetBossTierByGuildLevel(guildLevel)
    local config = self:GetGuildBossIdConfig()
    return config[guildLevel]
end

return GuildBossConfig