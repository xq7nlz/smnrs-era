--- @class ExchangeEventConfig
ExchangeEventConfig = Class(ExchangeEventConfig)

function ExchangeEventConfig:Ctor()
    ---@type number
    self.id = nil
    ---@type ItemIconData
    self.itemIconData = nil
    ---@type List
    self.listRewardItem = List()
    ---@type number
    self.limit = nil
    ---@type number
    self.chapRequired = nil
end

--- @return void
function ExchangeEventConfig:ParsedData(data)
    self.id = tonumber(data["id"])
    self.itemIconData = ItemIconData.CreateInstance(ResourceType.Money, tonumber(data["money_type"]), tonumber(data["money_value"]))
    self.limit = tonumber(data["limit"])
    if data.chap_required ~= nil then
        self.chapRequired = tonumber(data.chap_required)
    end
end

---@param x ExchangeEventConfig
---@param y ExchangeEventConfig
function ExchangeEventConfig.GetPriceMethod(x,y)
    if (x.itemIconData.quantity > y.itemIconData.quantity) then
        return 1
    else
        return -1
    end
   --return tonumber(-exchangeEventConfig.itemIconData.quantity)
end

--- @return void
function ExchangeEventConfig:AddReward(data)
    self.listRewardItem:Add(RewardInBound.CreateByParams(data):GetIconData())
end

--- @return void
function ExchangeEventConfig:SubMoney(_number)
    local number = _number
    if number == nil then
        number = 1
    end
    InventoryUtils.Sub(self.itemIconData.type, self.itemIconData.itemId, self.itemIconData.quantity * number)
end

--- @return List
function ExchangeEventConfig.GetListExchangeConfigPath(path)
    local list = List()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    ---@type ExchangeEventConfig
    local cacheExchange = nil
    for i = 1, #parsedData do
        if parsedData[i].id ~= nil then
            cacheExchange = ExchangeEventConfig()
            cacheExchange:ParsedData(parsedData[i])
            list:Add(cacheExchange)
        end
        cacheExchange:AddReward(parsedData[i])
    end

    list:SortWithMethod(ExchangeEventConfig.GetPriceMethod)

    return list
end