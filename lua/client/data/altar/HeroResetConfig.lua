local HERO_RESET_CONFIG = "csv/altar/altar_config.csv"

--- @class HeroResetConfig
HeroResetConfig = Class(HeroResetConfig)

--- @return void
function HeroResetConfig:Ctor()
    ---@type number
    self.starLimit = nil
    ---@type number
    self.moneyType = nil
    ---@type number
    self.moneyValue = nil

    self:InitData()
end

--- @return void
function HeroResetConfig:InitData()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(HERO_RESET_CONFIG)
    self:ParseCsv(parsedData[1])
end

--- @return void
--- @param data string
function HeroResetConfig:ParseCsv(data)
    self.starLimit = tonumber(data["hero_reset_star_limit"])
    self.moneyType = tonumber(data["reset_money_type"])
    self.moneyValue = tonumber(data["reset_money_value"])
end

return HeroResetConfig