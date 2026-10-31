local QUEST_CONFIG = "/summon_quest.csv"
local SUMMON_PRICE = "/summon_price.csv"

--- @class EventNewHeroSummonConfig
EventNewHeroSummonConfig = Class(EventNewHeroSummonConfig)

function EventNewHeroSummonConfig:Ctor(path)
    --- @type string
    self.path = path
    --- @type table
    self.priceRateUp = nil
    --- @type EventPityData
    self.eventPityConfig = nil
end

function EventNewHeroSummonConfig:GetInfoRateUp(type, quantity)
    return self.priceRateUp[type][quantity]
end

--- @return number
--- @param quantity number
--- @param summonType SummonType
function EventNewHeroSummonConfig:GetSummonRateUpPrice(summonType, quantity)
    if self.priceRateUp == nil then
        self.priceRateUp = {}
        local dataParse = CsvReaderUtils.ReadAndParseLocalFile(self.path .. SUMMON_PRICE)
        for _, data in ipairs(dataParse) do
            local summonType = tonumber(data['summon_type'])
            self.priceRateUp[summonType] = self.priceRateUp[summonType] or {}
            local summonNumber = tonumber(data['summon_number'])
            self.priceRateUp[summonType][summonNumber] = HeroSummonPrice(data)
        end
    end
    return self:GetInfoRateUp(summonType, quantity)
end

--- @return  number
function EventNewHeroSummonConfig:GetFreeInterval()
    if self.freeInterval == nil then
        local dataParse = CsvReaderUtils.ReadAndParseLocalFile(self.path .. SUMMON_PRICE)
        self.freeInterval = tonumber(dataParse[1].free_summon_interval)
    end
    return self.freeInterval
end

--- @return  number, number
function EventNewHeroSummonConfig:GetHeroIdAndStar()
    if self.heroId == nil then
        local dataParse = CsvReaderUtils.ReadAndParseLocalFile(self.path .. SUMMON_PRICE)
        self.heroId = tonumber(dataParse[1].hero_id)
        self.heroStar = tonumber(dataParse[1].hero_star)
    end
    return self.heroId, self.heroStar
end

---@return List --<QuestElementConfig>
function EventNewHeroSummonConfig:GetListQuest()
    if self.lisQuest == nil then
        local path = self.path .. QUEST_CONFIG
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("Get EventConfig nil %s", path))
            return
        end
        --- @type List
        self.lisQuest = List()
        --- @type QuestElementConfig
        local questConfig
        for i = 1, #parsedData do
            local questId = parsedData[i].quest_id
            if questId ~= nil then
                questConfig = QuestElementConfig.GetInstanceFromCsv(parsedData[i])
                self.lisQuest:Add(questConfig)
            else
                questConfig:AddResData(RewardInBound.CreateByParams(parsedData[i]))
            end
        end
    end
    return self.lisQuest
end