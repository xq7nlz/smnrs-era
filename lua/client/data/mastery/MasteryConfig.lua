require "lua.client.data.Mastery.SkillMasteryConfig"
require "lua.client.data.Mastery.MasteryUpgradePriceConfig"
require "lua.client.data.Mastery.MasteryResetPriceConfig"

local MASTERY_UPGRADE_PATH = "csv/mastery/mastery_upgrade_price.csv"
local MASTERY_UNLOCK_PATH = "csv/mastery/mastery_config.csv"
local MASTERY_RESET_PATH = "csv/mastery/mastery_reset_price.csv"

--- @class MasteryConfig
MasteryConfig = Class(MasteryConfig)

--- @return void
function MasteryConfig:Ctor()
    --- @type Dictionary --<class, Dictionary --<skill, SkillMasteryConfig>>
    self.skillMasteryDictionary = Dictionary()
    --- @type Dictionary --<lv, MasteryUpgradePriceConfig>
    self.masteryUpgradePriceDictionary = self:GetMasteryUpgradePriceDictionary()
    --- @type Dictionary --<lv, MasteryResetPriceConfig>
    self.masteryResetPriceDictionary = self:GetMasteryResetPriceDictionary()
    --- @type number
    self.basicMasteryLevelToUnlockCustomMastery = self:GetBasicMasteryLevelToUnlockCustomMastery()
end

--- @return Dictionary<key, value>
--- @param summonerId number
function MasteryConfig:GetSkillMasteryDictionary(summonerId)
    local data = self.skillMasteryDictionary:Get(summonerId)
    if data == nil then
        data = Dictionary()
        for i = 1, 6 do
            local skill = SkillMasteryConfig()
            local parsedData = CsvReaderUtils.ReadAndParseLocalFile(ResourceMgr.GetHeroesConfig():GetSummonerCsv():GetMastery(summonerId, i))
            skill:ParseCsv(parsedData)
            data:Add(i, skill)
        end
        self.skillMasteryDictionary:Add(summonerId, data)
    end
    return data
end

--- @return Dictionary<key, value>
function MasteryConfig:GetMasteryUpgradePriceDictionary()
    local dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(MASTERY_UPGRADE_PATH)
    for i = 1, #parsedData do
        local data = MasteryUpgradePriceConfig()
        data:ParseCsv(parsedData[i])
        dict:Add(data.level, data)
    end
    return dict
end

--- @return number
function MasteryConfig:GetBasicMasteryLevelToUnlockCustomMastery()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(MASTERY_UNLOCK_PATH)
    return tonumber(parsedData[1].mastery_milestone)
end

--- @return Dictionary<key, value>
function MasteryConfig:GetMasteryResetPriceDictionary()
    local dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(MASTERY_RESET_PATH)
    for i = 1, #parsedData do
        local data = MasteryResetPriceConfig()
        data:ParseCsv(parsedData[i])
        dict:Add(data.level, data)
    end
    return dict
end

return MasteryConfig