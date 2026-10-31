require "lua.client.data.Guild.GuildConfig"
require "lua.client.data.Guild.GuildLevel"
require "lua.client.data.Guild.RankingRewardByRangeConfig"

--- @class GuildDataConfig
GuildDataConfig = Class(GuildDataConfig)

function GuildDataConfig:Ctor()
    --- @type GuildConfig
    self.guildConfig = nil
    --- @type GuildLevel
    self.guildLevel = nil
    --- @type RewardInBound
    self._guildCheckInReward = nil
    --- @type number
    self.guildBonusExpCheckIn = nil
    --- @type GuildWarDataConfig
    self._guildWarDataConfig = nil

    self:_InitGuildConfig()
end

function GuildDataConfig:_InitGuildConfig()
    local guildConfig = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_CONFIG_PATH)
    self.guildConfig = GuildConfig(guildConfig)

    local guildLevel = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_LEVEL_PATH)
    self.guildLevel = GuildLevel(guildLevel)

    local guildCheckInConfig = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_CHECK_IN_PATH)
    --- @type RewardInBound
    self._guildCheckInReward = RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GUILD_PREMIUM_COIN, tonumber(guildCheckInConfig[1].guild_coin_per_check_in))
    self.guildBonusExpCheckIn = tonumber(guildCheckInConfig[1].guild_exp_per_check_in)
end

--- @return RewardInBound
function GuildDataConfig:GetCheckInRewardConfig()
    return self._guildCheckInReward
end

--- @return GuildWarDataConfig
function GuildDataConfig:GetGuildWarDataConfig()
    if self._guildWarDataConfig == nil then
        require "lua.client.data.Guild.GuildWarDataConfig"
        self._guildWarDataConfig = GuildWarDataConfig()
    end
    return self._guildWarDataConfig
end

return GuildDataConfig