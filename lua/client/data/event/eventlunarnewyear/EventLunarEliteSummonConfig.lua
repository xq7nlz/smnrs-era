local ELITE_SUMMON_CONFIG = "elite_summon_config.csv"
local ELITE_SUMMON_PRICE_CONFIG = "elite_summon_price.csv"
local ELITE_SUMMON_RATE_CONFIG = "elite_summon_rate.csv"
local ELITE_SUMMON_WISH_LIST = "elite_summon_wish_list.csv"

--- @class EventLunarEliteSummonConfig
EventLunarEliteSummonConfig = Class(EventLunarEliteSummonConfig)


function EventLunarEliteSummonConfig:Ctor(path)
    self.path = string.format("%s/%s", path, "elite_summon")

    self.maxSummonByGem = nil
    --- @type Dictionary
    self.summonPriceConfig = nil
    --- @type Dictionary
    self.wishListDict = nil
    --- @type Dictionary
    self.eliteSummonRate = nil
end

--- @return number
function EventLunarEliteSummonConfig:GetMaxSummonByGem()
    if self.maxSummonByGem == nil then
        local path = string.format("%s/%s", self.path, ELITE_SUMMON_CONFIG)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        self.maxSummonByGem = tonumber(parsedData[1].max_summon_number_by_gem)
    end
    return self.maxSummonByGem
end

--- @return Dictionary
function EventLunarEliteSummonConfig:GetSummonPriceDict()
    if self.summonPriceConfig == nil then
        self.summonPriceConfig = Dictionary()
        local path = string.format("%s/%s", self.path, ELITE_SUMMON_PRICE_CONFIG)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        for i = 1, #parsedData do
            local id = tonumber(parsedData[i].id)
            local sumNumber = tonumber(parsedData[i].summon_number)

            local moneyType = tonumber(parsedData[i].money_type)
            local moneyValue = tonumber(parsedData[i].money_value)
            local rewardInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, moneyType, moneyValue)

            local tableMoney = self.summonPriceConfig:Get(id)
            if tableMoney == nil then
                tableMoney = {}
                self.summonPriceConfig:Add(id, tableMoney)
            end
            tableMoney.sumNumber = sumNumber
            tableMoney.rewardInBound = rewardInBound
        end
    end
    return self.summonPriceConfig
end

--- @return { sumNumber, rewardInBound : RewardInBound }
--- @param id number
function EventLunarEliteSummonConfig:GetSummonPriceById(id)
    return self:GetSummonPriceDict():Get(id)
end

--- @return Dictionary
function EventLunarEliteSummonConfig:GetWishListByDictionary()
    if self.wishListDict == nil then
        self.wishListDict = Dictionary()
        local path = string.format("%s/%s", self.path, ELITE_SUMMON_WISH_LIST)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        for i = 1, #parsedData do
            local id = tonumber(parsedData[i].id)
            local pity = tonumber(parsedData[i].pity_number)
            local data = {}
            data.pity = pity
            local rewardInBound = RewardInBound.CreateByParams(parsedData[i])
            data.rewardInBound = rewardInBound
            self.wishListDict:Add(id, data)
        end
    end
    return self.wishListDict
end

--- @return Dictionary
function EventLunarEliteSummonConfig:GetEliteSummonRate()
    if self.eliteSummonRate == nil then
        self.eliteSummonRate = Dictionary()
        local path = string.format("%s/%s", self.path, ELITE_SUMMON_RATE_CONFIG)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        for i = 1, #parsedData do
            local id = tonumber(parsedData[i].id)
            local isShow = false
            if parsedData[i].is_show ~= nil then
                isShow = true
            end
            local tableConfig = {}
            local rewardInBound = RewardInBound.CreateByParams(parsedData[i])
            tableConfig.rewardInBound = rewardInBound
            tableConfig.isShow = isShow
            self.eliteSummonRate:Add(id, tableConfig)
        end
    end
    return self.eliteSummonRate
end

--- @return List
function EventLunarEliteSummonConfig:GetListShowRewardRate()
    if self.eliteSummonRate == nil then
        self:GetEliteSummonRate()
    end
    if self.listEliteSummonShow == nil then
        self.listEliteSummonShow = List()
        --- @param v {rewardInBound, isShow}
        for k, v in pairs(self.eliteSummonRate:GetItems()) do
            if v.isShow == true then
                self.listEliteSummonShow:Add(v)
            end
        end
    end
    return self.listEliteSummonShow
end