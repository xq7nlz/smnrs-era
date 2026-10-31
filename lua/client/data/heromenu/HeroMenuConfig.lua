require "lua.client.data.HeroMenu.HeroLevelDataConfig"
require "lua.client.data.HeroMenu.HeroLevelCapConfig"
require "lua.client.data.HeroMenu.HeroEvolvePriceConfig"
require "lua.client.data.HeroMenu.HeroEvolveConfig"

local HERO_BASE_STAR_PATH = "csv/client/hero_base_star.csv"
local HERO_EVOLVE_MAIN_PATH = "csv/hero_level/hero_evolve_price.csv"
local HERO_EVOLVE_SPECIFIC_PATH = "csv/client/csv_hero_evolve_price_config.json"
local HERO_LEVEL_DATA_PATH = "csv/hero_level/hero_level_price.csv"
local HERO_LEVEL_CAP_PATH = "csv/hero_level/hero_level_cap.csv"
local HERO_COLLECTION_PATH = "csv/client/hero_collection.csv"
local HERO_RECYCLE_MAIN_PATH = "csv/hero_level/hero_recycle_config.csv"

--- @class HeroMenuConfig
HeroMenuConfig = Class(HeroMenuConfig)

--- @return void
function HeroMenuConfig:Ctor()
    --- @type Dictionary --<id, HeroLevelDataConfig>
    self.heroLevelDataDictionary = nil
    --- @type Dictionary --<id, HeroLevelCapConfig>
    self.heroLevelCapDictionary = nil
    --- @type Dictionary --<id, HeroSkillLevelConfig>
    self.heroSkillLevelDictionary = nil
    --- @type Dictionary --<star, HeroEvolvePriceConfig>
    self.heroEvolvePriceConfigMain = nil
    --- @type Dictionary --<heroId, Dictionary <star, HeroEvolvePriceConfig>>
    self.heroEvolvePriceDict = nil
    --- @type Dictionary --<id, star>
    self.dictHeroBaseStar = nil
    --- @type List --<id>
    self.listHeroCollection = self:GetListHeroCollection()
    --- @type Dictionary --<id>
    self.heroScaleDict = self:GetHeroScale()
    --- @type Dictionary -- <star, listHeroId>
    self.numberOfHeroBaseByStar = nil
    --- @type HeroEvolveConfig
    self.heroEvolveConfig = nil
end

--- @return Dictionary
--- @param heroId number
function HeroMenuConfig:GetDictHeroBaseStar(heroId)
    self:_InitHeroBaseStar()
    return self.dictHeroBaseStar:Get(heroId)
end

function HeroMenuConfig:_InitHeroBaseStar()
    if self.dictHeroBaseStar == nil then
        self.numberOfHeroBaseByStar = Dictionary()

        ---@type Dictionary
        self.dictHeroBaseStar = Dictionary()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(HERO_BASE_STAR_PATH)
        for i = 1, #parsedData do
            local id = tonumber(parsedData[i].id)
            local star = tonumber(parsedData[i].star)

            self.dictHeroBaseStar:Add(id, star)

            if self.numberOfHeroBaseByStar:IsContainKey(star) == false then
                local newList = List()
                newList:Add(id)
                self.numberOfHeroBaseByStar:Add(star, newList)
            else
                --- @type List
                local existingList = self.numberOfHeroBaseByStar:Get(star)
                existingList:Add(id)
                self.numberOfHeroBaseByStar:Add(star, existingList)
            end
        end
    end
end

--- @return Dictionary
--- @param linkCsv string
function HeroMenuConfig:_GetHeroEvolvePriceConfigByPath(linkCsv)
    local dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(linkCsv)
    for i = 1, #parsedData do
        local data = HeroEvolvePriceConfig()
        data:ParseCsv(parsedData[i])
        dict:Add(data.star, data)
    end
    return dict
end

--- @return Dictionary
function HeroMenuConfig:GetOrbNumberByStarConfigByPath(star)
    local dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(HERO_RECYCLE_MAIN_PATH)
    for i = 1, #parsedData do
        local star = tonumber(parsedData[i].star)
        local number = tonumber(parsedData[i].orb_number)
        dict:Add(star, number)
    end
    if star > 0 then
        return dict:Get(star)
    else
        return 0
    end
end

--- @return Dictionary
function HeroMenuConfig:_GetHeroEvolvePriceConfigDict()
    local dict = self:_GetHeroEvolvePriceConfigByPath(HERO_EVOLVE_MAIN_PATH)
    return dict
end

--- @return Dictionary
--- @param heroId number
function HeroMenuConfig:GetHeroEvolvePriceConfig(heroId, star)
    local dict = self:GetHeroEvolvePriceConfigDictionary(heroId)
    if dict == nil then
        return self:GetHeroEvolvePriceConfigMain(star)
    else
        return dict:Get(star)
    end
end

--- @return Dictionary
--- @param star number
function HeroMenuConfig:GetHeroEvolvePriceConfigMain(star)
    if self.heroEvolvePriceConfigMain == nil then
        self.heroEvolvePriceConfigMain = self:_GetHeroEvolvePriceConfigByPath(HERO_EVOLVE_MAIN_PATH)
    end
    return self.heroEvolvePriceConfigMain:Get(star)
end

--- @return Dictionary
--- @param heroId number
function HeroMenuConfig:GetHeroEvolvePriceConfigDictionary(heroId)
    if self.heroEvolvePriceDict == nil then
        local decodeData = CsvReaderUtils.ReadAndParseLocalFile(HERO_EVOLVE_SPECIFIC_PATH, nil, true)
        self.heroEvolvePriceDict = Dictionary()
        for _, data in ipairs(decodeData) do
            self.heroEvolvePriceDict:Add(tonumber(data['heroId']), self:_GetHeroEvolvePriceConfigByPath(data['linkCsv']))
        end
    end
    return self.heroEvolvePriceDict:Get(heroId)
end


--- @return Dictionary
--- @param level number
function HeroMenuConfig:GetHeroLevelDataDictionary(level)
    if self.heroLevelDataDictionary == nil then
        self.heroLevelDataDictionary = Dictionary()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(HERO_LEVEL_DATA_PATH)
        for i = 1, #parsedData do
            local data = HeroLevelDataConfig()
            data:ParseCsv(parsedData[i])
            self.heroLevelDataDictionary:Add(data.level, data)
        end
    end
    return self.heroLevelDataDictionary:Get(level)
end

--- @return Dictionary
--- @param star number
function HeroMenuConfig:GetHeroLevelCapDictionary(star)
    if self.heroLevelCapDictionary == nil then
        self.heroLevelCapDictionary = Dictionary()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(HERO_LEVEL_CAP_PATH)
        for i = 1, #parsedData do
            local data = HeroLevelCapConfig()
            data:ParseCsv(parsedData[i])
            self.heroLevelCapDictionary:Add(data.star, data)
        end
    end
    return self.heroLevelCapDictionary:Get(star)
end

--- @return Dictionary
function HeroMenuConfig:GetListHeroCollection()
    ---@type List
    local list = List()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(HERO_COLLECTION_PATH)
    for i = 1, #parsedData do
        local heroId = tonumber(parsedData[i].id)
        if list:IsContainValue(heroId) == false then
            list:Add(heroId)
        end
    end
    return list
end

--- @return Dictionary
function HeroMenuConfig:GetHeroScale()
    ---@type Dictionary
    local dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(HERO_COLLECTION_PATH)
    for i = 1, #parsedData do
        local heroId = tonumber(parsedData[i].id)
        local scale = tonumber(parsedData[i].scale)
        if dict:IsContainValue(heroId) == false then
            dict:Add(heroId,scale)
        end
    end
    return dict
end

--- @param star number
--- @param heroFactionType HeroFactionType
function HeroMenuConfig:GetNumberOfHeroBaseByStarAndFaction(star, heroFactionType)
    self:_InitHeroBaseStar()
    --- @type List
    local listHeroByStar = self.numberOfHeroBaseByStar:Get(star)
    if heroFactionType == nil then
        return listHeroByStar:Count()
    else
        local numberOfHero = 0
        for i = 1, listHeroByStar:Count() do
            local heroId = listHeroByStar:Get(i)
            if ClientConfigUtils.GetFactionIdByHeroId(heroId) == heroFactionType then
                numberOfHero = numberOfHero + 1
            end
        end
        return numberOfHero
    end
end

--- @return HeroEvolveConfig
function HeroMenuConfig:GetHeroEvolveConfig()
    if self.heroEvolveConfig == nil then
        self.heroEvolveConfig = HeroEvolveConfig()
        self.heroEvolveConfig:ParseCsv()
    end
    return self.heroEvolveConfig
end

return HeroMenuConfig