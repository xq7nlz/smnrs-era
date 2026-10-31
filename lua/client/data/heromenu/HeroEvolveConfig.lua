--- @class HeroEvolveConfig
HeroEvolveConfig = Class(HeroEvolveConfig)

local HERO_EVOLVE_CONFIG_PATH = "csv/hero_level/hero_evolve_config.csv"

--- @return void
function HeroEvolveConfig:Ctor()
    ---@type number
    self.heroMaxStar = 0
    ---@type number
    self.summonerMaxStar = 0
end

--- @return void
function HeroEvolveConfig:ParseCsv()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(HERO_EVOLVE_CONFIG_PATH)
    self.heroMaxStar = tonumber(parsedData[1].hero_max_star)
    self.summonerMaxStar = tonumber(parsedData[1].summoner_max_star)
end