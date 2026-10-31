local PITY_CONFIG = "csv/event/event_rate_up/data_%d/pity_config.csv"
local RATE_UP_CUMULATIVE = "csv/event/event_rate_up/data_%d/event_rate_up_cumulative_rate.csv"
local SUMMON_RATE_UP_PRICE = "csv/event/event_rate_up/data_%d/event_rate_up_price.csv"

--- @class EventRateUpCumulativeData
EventRateUpCumulativeData = Class(EventRateUpCumulativeData)
function EventRateUpCumulativeData:Ctor(data)
    self.heroId = tonumber(data['hero_id'])
end

--- @class EventPityData
EventPityData = Class(EventPityData)
function EventPityData:Ctor(data)
    self.summonPoint = tonumber(data['summon_point'])
    self.pity_enable = MathUtils.ToBoolean(data['pity_enable'])
end


--- @class EventRateUp
EventRateUp = Class(EventRateUp)

--- @param dataId number
function EventRateUp:Ctor(dataId)
    --- @type number
    self.dataId = dataId
    --- @type EventRateUpCumulativeData
    self.rateUpCumulativeData = nil
    --- @type table
    self.priceRateUp = nil
    --- @type EventPityData
    self.eventPityConfig = nil
end

function EventRateUp:GetInfoRateUp(type, quantity)
    return self.priceRateUp[type][quantity]
end
--- @return number
--- @param quantity number
function EventRateUp:GetSummonRateUpPrice(summonType, quantity)
    if self.priceRateUp == nil then
        self.priceRateUp = {}
        local dataParse = CsvReaderUtils.ReadAndParseLocalFile(string.format(SUMMON_RATE_UP_PRICE, self.dataId))
        for _, data in ipairs(dataParse) do
            local summonType = tonumber(data['summon_type'])
            self.priceRateUp[summonType] = self.priceRateUp[summonType] or {}
            local summonNumber = tonumber(data['summon_number'])
            self.priceRateUp[summonType][summonNumber] = HeroSummonPrice(data)
        end
    end
    return self:GetInfoRateUp(summonType, quantity)
end

--- @return EventRateUpCumulativeData
function EventRateUp:GetRateUpCumulative()
    if self.rateUpCumulativeData == nil then
        local dataParse = CsvReaderUtils.ReadAndParseLocalFile(string.format(RATE_UP_CUMULATIVE, self.dataId))
        self.rateUpCumulativeData = EventRateUpCumulativeData(dataParse[1])
    end
    return self.rateUpCumulativeData
end

--- @return EventPityData
function EventRateUp:GetPityConfig()
    if self.eventPityConfig == nil then
        local dataParse = CsvReaderUtils.ReadAndParseLocalFile(string.format(PITY_CONFIG, self.dataId))
        self.eventPityConfig = EventPityData(dataParse[1])
    end
    return self.eventPityConfig
end

