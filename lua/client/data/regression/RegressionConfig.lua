require("lua.client.data.Regression.RegressionPrice")
require("lua.client.data.Regression.RegressionFoodRefund")

--- @class RegressionConfig
RegressionConfig = Class(RegressionConfig)

function RegressionConfig:Ctor()
    ---@type number
    self.baseStar = nil
    ---@type number
    self.minStar = nil
    ---@type Dictionary
    self.dictPrice = nil
    ---@type Dictionary
    self.dictRefund = nil
end

---@return Dictionary
function RegressionConfig:GetDictPrice()
    if self.dictPrice == nil then
        self.dictPrice = Dictionary()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile("csv/regression/regression_price.csv")
        ---@type RegressionPrice
        local cache
        for i = 1, #parsedData do
            if parsedData[i].star ~= nil then
                cache = RegressionPrice(parsedData[i])
                self.dictPrice:Add(cache.star, cache)
            else
                cache:AddData(parsedData[i])
            end
        end
    end
    return self.dictPrice
end

---@return Dictionary
function RegressionConfig:GetDictFoodRefund()
    if self.dictRefund == nil then
        self.dictRefund = Dictionary()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile("csv/regression/food_refund_config.csv")
        ---@type RegressionFoodRefund
        local cache
        for i = 1, #parsedData do
            if parsedData[i].star ~= nil then
                cache = RegressionFoodRefund(parsedData[i])
                self.dictRefund:Add(cache.star, cache)
            else
                cache:AddData(parsedData[i])
            end
        end
    end
    return self.dictRefund
end

function RegressionConfig:ReadCsvConfig()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile("csv/regression/regression_config.csv")
    self.baseStar = tonumber(parsedData[1].base_star)
    self.minStar = tonumber(parsedData[1].min_star)
end

---@return number
function RegressionConfig:GetBaseStar()
    if self.baseStar == nil then
        self:ReadCsvConfig()
    end
    return self.baseStar
end

---@return number
function RegressionConfig:GetMinStar()
    if self.minStar == nil then
        self:ReadCsvConfig()
    end
    return self.minStar
end

return RegressionConfig