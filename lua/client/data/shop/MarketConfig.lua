require "lua.client.data.Shop.MarketItemRateConfig"
require "lua.client.data.Shop.GroupMarketItemRateConfig"

--- @class MarketUpgradeData
MarketUpgradeData = Class(MarketUpgradeData)

function MarketUpgradeData:Ctor()
    self.moneyType = nil
    self.moneyValue = nil
end
function MarketUpgradeData:SetData(data)
    self.moneyType = tonumber(data['money_type'])
    self.moneyValue = tonumber(data['money_value'])
end
--- @class MarketUpgradeDataList
MarketUpgradeDataList = Class(MarketUpgradeDataList)
function MarketUpgradeDataList:Ctor()
    --- @type List | MarketUpgradeData
    self.listData = List()
end
---@return List / RewardInBound
function MarketUpgradeDataList:GetRewardInboundList()
    local listReward = List()
    ---@param v MarketUpgradeData
    for _, v in ipairs(self.listData:GetItems()) do
        local convertData = RewardInBound.CreateBySingleParam(ResourceType.Money, v.moneyType, v.moneyValue)
        listReward:Add(convertData)
    end
    return listReward
end
function MarketUpgradeDataList:AddData(data)
    local marketUpgradeData = MarketUpgradeData()
    marketUpgradeData:SetData(data)
    self.listData:Add(marketUpgradeData)
end

--- @class MarketConfig
MarketConfig = Class(MarketConfig)

--- @return void
function MarketConfig:Ctor()
    --- @type number
    self.maxItem = nil
    --- @type number
    self.refreshPrice = nil
    --- @type number
    self.refreshMoneyType = nil
    --- @type Dictionary|{number, groupMarketItemRateConfig : GroupMarketItemRateConfig}
    self.groupMarketItemDict = nil
    --- @type Dictionary
    self.dataUpgradeDict = Dictionary()
    --- @type number
    self.maxLevel = nil
end

--- @return void
function MarketConfig:ParseCsv(path)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    self.maxItem = tonumber(parsedData[1]["max_item"])
    self.refreshPrice = tonumber(parsedData[1]["refresh_price_amount"])
    self.refreshMoneyType = tonumber(parsedData[1]["refresh_price_money_type"])
end

--- @param path string
function MarketConfig:ParseItemRateConfig(path)
    self.groupMarketItemDict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    --- @type GroupMarketItemRateConfig
    local groupMarketItemRateConfig
    for i = 1, #parsedData do
        local id = tonumber(parsedData[i].id)
        if MathUtils.IsNumber(id) then
            groupMarketItemRateConfig = GroupMarketItemRateConfig()
            self.groupMarketItemDict:Add(id, groupMarketItemRateConfig)
        end
        local groupNumber = tonumber(parsedData[i].group_number)
        if MathUtils.IsNumber(groupNumber) then
            groupMarketItemRateConfig.groupNumber = groupNumber
        end
        groupMarketItemRateConfig:AddItemData(parsedData[i])
    end
end

--- @return Dictionary
function MarketConfig:GetItemRateConfig()
    return self.groupMarketItemRateConfig
end

--- @return GroupMarketItemRateConfig
--- @param slotIndex number
function MarketConfig:FindGroupMarketItemRateBySlot(slotIndex)
    if self.groupMarketItemDict == nil then
        return nil
    end
    --- @param v GroupMarketItemRateConfig
    for _, v in pairs(self.groupMarketItemDict:GetItems()) do
        slotIndex = slotIndex - v.groupNumber
        if slotIndex <= 0 then
            return v
        end
    end
    return nil
end
function MarketConfig:ParseUpgradeData(path)
    self.dataUpgradeDict:Clear()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)

    ----- @type MarketUpgradeDataList
    local dataList
    for i = 1, #parsedData do
        if parsedData[i] ~= nil then
            if parsedData[i]['level'] ~= nil then
                dataList = MarketUpgradeDataList()
                dataList:AddData(parsedData[i])
                self.dataUpgradeDict:Add(tonumber(parsedData[i]['level']), dataList)
            else
                dataList:AddData(parsedData[i])
            end
        end
    end
    self.maxLevel = self.dataUpgradeDict:Count()
end

----@return MarketUpgradeDataList
function MarketConfig:GetUpgradeMoneyList(level)
    if self.dataUpgradeDict:IsContainKey(level) then
        return self.dataUpgradeDict:Get(level)
    end
    return nil
end