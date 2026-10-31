require "lua.client.data.Altar.HeroAltarLevelReward"
require "lua.client.data.Altar.HeroAltarStarReward"

--- @class HeroAltarConfig
HeroAltarConfig = Class(HeroAltarConfig)

--- @return void
function HeroAltarConfig:Ctor()
    --- @type Dictionary --<level, List<HeroAltarLevelReward>>
    self.heroAltarLevelRewardDictionary = self:GetHeroAltarLevelRewardDictionary()
    --- @type Dictionary --<star, List<HeroAltarStarReward>>
    self.heroAltarStarRewardDictionary = self:GetHeroAltarStarRewardDictionary()
end

--- @return Dictionary<key, value>
function HeroAltarConfig:GetHeroAltarLevelRewardDictionary()
    local dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.ALTAR_LEVEL_PATH)
    for i = 1, #parsedData do
        --- @type HeroAltarLevelReward
        local data = HeroAltarLevelReward()
        data:ParseCsv(parsedData[i])
        dict:Add(data.level, data)
    end
    return dict
end

--- @return Dictionary<key, value>
function HeroAltarConfig:GetHeroAltarStarRewardDictionary()
    local dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.ALTAR_STAR_PATH)
    for i = 1, #parsedData do
        --- @type HeroAltarStarReward
        local data = HeroAltarStarReward()
        data:ParseCsv(parsedData[i])
        dict:Add(data.star, data)
    end
    return dict
end

return HeroAltarConfig