--- @class CommonGuildBossConfig
CommonGuildBossConfig = Class(CommonGuildBossConfig)

function CommonGuildBossConfig:Ctor()
    --- @type number
    self.blockChallengeBossDuration = nil
    --- @type number
    self.maxGuildBossStamina = nil
    --- @type number
    self.guildBossStaminaPerDay = nil

    self:_Init()
end

function CommonGuildBossConfig:_Init()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_BOSS_CONFIG_PATH)
    self.blockChallengeBossDuration = tonumber(parsedData[1].block_challenge_boss_duration)
    self.maxGuildBossStamina = tonumber(parsedData[1].max_guild_boss_stamina)
    self.guildBossStaminaPerDay = tonumber(parsedData[1].guild_boss_stamina_per_day)
end