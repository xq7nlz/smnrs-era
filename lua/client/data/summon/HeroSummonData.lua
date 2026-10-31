--- @class HeroSummonPrice
HeroSummonPrice = Class(HeroSummonPrice)

function HeroSummonPrice:Ctor(data)
    self.gemPrice = tonumber(data['gem_price'])
    self.summonPrice = tonumber(data['summon_price'])
    self.moneyType = tonumber(data['money_type'])
    --- @type RewardInBound
    self.point = RewardInBound.CreateByParams(data)
end

--- @class HeroSummonData
HeroSummonData = Class(HeroSummonData)

--- @return void
function HeroSummonData:Ctor()
    --- @type Dictionary
    self.freeInterval = nil
    --- @type Dictionary
    self.adsLimitDict = nil
    --- @type table
    self.price = nil
    --- @type table
    self.priceRateUp = nil
end

----------- GETTER -----------------------------------

--- @return  number
--- @param summonType SummonType
function HeroSummonData:GetFreeInterval(summonType)
    if self.freeInterval == nil then
        local dataParse = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.SUMMON_FREE_INTERVAL)
        self.freeInterval = Dictionary()
        for i, v in ipairs(dataParse) do
            self.freeInterval:Add(tonumber(v['summon_type']), tonumber(v['summon_free_interval']))
        end
    end
    return self.freeInterval:Get(summonType)
end

--- @return  number
--- @param summonType SummonType
function HeroSummonData:GetAdsLimit(summonType)
    if self.adsLimitDict == nil then
        local dataParse = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.SUMMON_FREE_INTERVAL)
        self.adsLimitDict = Dictionary()
        for i, v in ipairs(dataParse) do
            self.adsLimitDict:Add(tonumber(v['summon_type']), tonumber(v['number_watch_ads_limit']))
        end
    end
    return self.adsLimitDict:Get(summonType)
end

--- @return number
--- @param summonType SummonType
--- @param quantity number
function HeroSummonData:GetSummonPrice(summonType, quantity)
    if self.price == nil then
        self.price = {}
        local dataParse = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.SUMMON_PRICE)
        for _, data in ipairs(dataParse) do
            local summonType = tonumber(data['summon_type'])
            self.price[summonType] = self.price[summonType] or {}
            local summonNumber = tonumber(data['summon_number'])
            self.price[summonType][summonNumber] = HeroSummonPrice(data)
        end
    end
    return self:GetInfo(summonType, quantity)
end
--- @return table
--- @param type SummonType
function HeroSummonData:GetInfo(type, quantity)
    return self.price[type][quantity]
end
return HeroSummonData
