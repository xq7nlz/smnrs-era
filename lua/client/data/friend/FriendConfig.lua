--- @class FriendConfig
FriendConfig = Class(FriendConfig)

--- @return void
function FriendConfig:Ctor()
    ---@type number
    self.scoutInterval = nil
    ----@type number
    self.maxStamina = nil
    ----@type number
    self.staminaRefreshInterval = nil
    ----@type number
    self.friendBossLevelDelta = nil
    ---@type number
    self.friendPointDailyLimit = nil

    self:InitData()
end

--- @return void
function FriendConfig:InitData()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.FRIEND_CONFIG_PATH)
    self:ParseCsv(parsedData[1])
end

--- @return void
function FriendConfig:ParseCsv(dataContent)
    self.scoutInterval = tonumber(dataContent["scout_interval"])
    self.maxStamina = tonumber(dataContent["max_stamina"])
    self.staminaRefreshInterval = tonumber(dataContent["stamina_regen_interval"])
    self.friendBossLevelDelta = tonumber(dataContent["friend_boss_level_delta"])
    self.friendPointDailyLimit = tonumber(dataContent["friend_point_daily_limit"])
end

return FriendConfig