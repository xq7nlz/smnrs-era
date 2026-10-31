--- @class CurrencyCollectionConfig
CurrencyCollectionConfig = Class(CurrencyCollectionConfig)

--- @return void
function CurrencyCollectionConfig:Ctor()
    ---@type List
    self.list = List()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.MONEY_COLLECTION_PATH)
    for i = 1, #parsedData do
        self.list:Add(tonumber(parsedData[i].id))
    end
end

--- @return boolean
---@param type MoneyType
function CurrencyCollectionConfig:IsContainMoneyType(type)
    return self.list:IsContainValue(type)
end

return CurrencyCollectionConfig