require "lua.client.data.MainCharacter.MainCharacterExpConfig"
require "lua.client.data.MainCharacter.SummonerPriceEvolveConfig"

--- @class MainCharacterConfig
MainCharacterConfig = Class(MainCharacterConfig)

--- @return void
function MainCharacterConfig:Ctor()
    --- @type Dictionary --<lv, MainCharacterExpConfig>
    self.mainCharacterExpDictionary = self:GetMainCharacterExpDictionary()
    --- @type Dictionary --<star, SummonerPriceEvolveConfig>
    self.mainSummonerEvolveDictionary = self:GetSummonEvolvePriceDictionary()
end

--- @return Dictionary<key, value>
function MainCharacterConfig:GetMainCharacterExpDictionary()
    local dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.MAIN_CHARACTER_EXP_PATH)
    ---@type MainCharacterExpConfig
    local cacheCharacter
    for i = 1, #parsedData do
        local data = MainCharacterExpConfig()
        data:ParseCsv(parsedData[i])
        if data.level ~= nil then
            cacheCharacter = data
            dict:Add(data.level, data)
        else
            cacheCharacter:AddReward(parsedData[i])
        end
    end
    return dict
end

function MainCharacterConfig:IsCanEvolve(star)
    ---@type HeroEvolveConfig
    local heroEvolveConfig = ResourceMgr.GetHeroMenuConfig():GetHeroEvolveConfig()
    local canEvolve = true
    if star < heroEvolveConfig.summonerMaxStar then
        ---@type SummonerPriceEvolveConfig
        local summonerPriceEvolveConfig = self.mainSummonerEvolveDictionary:Get(star + 1)
        ---@param v ItemIconData
        for _, v in ipairs(summonerPriceEvolveConfig.listMoney:GetItems()) do
            if InventoryUtils.Get(v.type, v.itemId) < v.quantity then
                canEvolve = false
                break
            end
        end
    else
        canEvolve = false
    end
    return canEvolve
end

--- @return Dictionary<key, value>
function MainCharacterConfig:GetSummonEvolvePriceDictionary()
    local dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.MAIN_CHARACTER_EVOLVE_PATH)
    for i = 1, #parsedData do
        local data = SummonerPriceEvolveConfig()
        data:ParseCsv(parsedData[i])
        dict:Add(data.star, data)
    end
    return dict
end

return MainCharacterConfig