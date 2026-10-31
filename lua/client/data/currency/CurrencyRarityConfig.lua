--- @class CurrencyRarityConfig
CurrencyRarityConfig = Class(CurrencyRarityConfig)

--- @return void
function CurrencyRarityConfig:Ctor()
    ---@type Dictionary
    self.dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile("csv/client/money_rarity.csv")
    for i = 1, #parsedData do
        self.dict:Add(tonumber(parsedData[i].id), tonumber(parsedData[i].rarity))
    end
end

--- @return number
---@param type MoneyType
function CurrencyRarityConfig:GetRarity(type)
    return self.dict:Get(type)
end

return CurrencyRarityConfig