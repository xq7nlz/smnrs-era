require "lua.client.core.network.playerData.common.MarketItemInBound"
--- @class EventMarketNewVersionConfig : MarketConfig
EventMarketNewVersionConfig = Class(EventMarketNewVersionConfig, MarketConfig)

local REFRESH_CONFIG_PATH = "csv/event/event_soul_shop/data_%s/soul_shop_refresh_config.csv"
local PRICE_VALUE_PATH = "csv/event/event_soul_shop/data_%s/soul_shop_price_value.csv"

--- @param marketConfigPath string
--- @param itemRateConfigPath string
--- @param dataId number
function EventMarketNewVersionConfig:Ctor(marketConfigPath, itemRateConfigPath, dataId)
    MarketConfig.Ctor(self)
    self.rewardPath = marketConfigPath
    self.dataId = dataId
end

---@return List
function EventMarketNewVersionConfig:GetListMarketItem(dataId)
    --- @type List
    local listReward = List()
    local path = string.format(self.rewardPath, self.dataId, dataId)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    for i = 1, #parserData do
        local data = parserData[i]
        ---@type CostInBound
        local cost = {}
        cost.value = tonumber(data["money_value"])
        cost.moneyType = tonumber(data["money_type"])
        ---@type MarketItemInBound
        local item = MarketItemInBound()
        item.id = tonumber(data["id"])
        item.reward = RewardInBound.CreateByParams(data)
        item.cost = cost
        item.numberItemCanBuy = tonumber(data["stock"])
        item.maxItem = tonumber(data["stock"])
        listReward:Add(item)
    end
    return listReward
end

---@return {moneyType, moneyValue}
function EventMarketNewVersionConfig:GetRefreshMoneyData()
    local path = string.format(REFRESH_CONFIG_PATH, self.dataId)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local data = parserData[1]
    ---@type {moneyType, moneyValue}
    local cost = {}
    cost.moneyType = tonumber(data["money_type"])
    cost.moneyValue = tonumber(data["money_value"])
    return cost
end

---@return {moneyType, moneyValue}
function EventMarketNewVersionConfig:GetDictPriceValueItem()
    local path = string.format(PRICE_VALUE_PATH, self.dataId)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local priceDict = Dictionary()
    for i = 1, #parserData do
        local data = parserData[i]
        local totalBought = tonumber(data["total_bought"])
        if totalBought ~= nil then
            local value = tonumber(data["price"])
            priceDict:Add(totalBought, value)
        end
    end
    return priceDict
end