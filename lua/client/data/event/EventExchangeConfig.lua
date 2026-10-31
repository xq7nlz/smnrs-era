local CSV_PATH = "csv/event/event_exchange/data_%s/exchange_reward.csv"

--- @class MaterialExchange
MaterialExchange = Class(MaterialExchange)

--- @return void
function MaterialExchange:Ctor()
    self.materialType = nil
    self.materialCount = nil
    self.requirement1 = nil
    self.requirement2 = nil
    self.requirement3 = nil
    self.requirement4 = nil
    self.requirement5 = nil
end

--- @return void
function MaterialExchange:ParsedData(data)
    self.materialType = tonumber(data["material_type"])
    self.materialCount = tonumber(data["material_amount"])
    self.requirement1 = tonumber(data["material_requirement_1"])
    self.requirement2 = tonumber(data["material_requirement_2"])
    self.requirement3 = tonumber(data["material_requirement_3"])
    self.requirement4 = tonumber(data["material_requirement_4"])
    self.requirement5 = tonumber(data["material_requirement_5"])
end

--- @return void
function MaterialExchange:GetIconData()
    ---@type ItemIconData
    local iconData = nil
    if self.materialType == 0 then
        iconData = HeroIconData.CreateInstance(ResourceType.Hero, self.requirement5, self.requirement1, self.requirement2, self.requirement4, self.materialCount)
    elseif self.materialType == 1 then
        iconData = ItemIconData.CreateInstance(ResourceType.ItemEquip, self.requirement5, self.materialCount)
        iconData.star = self.requirement1
        iconData.rarity = self.requirement2
    elseif self.materialType == 2 then
        iconData = ItemIconData.CreateInstance(ResourceType.ItemArtifact, self.requirement5, self.materialCount)
        iconData.rarity = self.requirement2
    end
    return iconData
end

--- @class ExchangeData
ExchangeData = Class(ExchangeData)

--- @return void
function ExchangeData:Ctor()
    self.id = nil
    self.rarity = nil
    self.limit = nil
    ---@type List --<MaterialExchange>
    self.listRequirement = List()
    ---@type List
    self.listReward = List()
    ---@type List
    self.listMoney = List()
end

--- @return void
function ExchangeData:SubMoney()
    ---@param v ItemIconData
    for i, v in pairs(self.listMoney:GetItems()) do
        v:SubToInventory()
    end
end

--- @return void
function ExchangeData:ParsedData(data)
    self.id = tonumber(data["id"])
    self.rarity = tonumber(data["rarity"])
    self.limit = tonumber(data["limit"])
    self:AddData(data)
end

--- @return void
function ExchangeData:AddData(data)
    if data["material_type"] ~= nil then
        local materialExchange = MaterialExchange()
        materialExchange:ParsedData(data)
        self.listRequirement:Add(materialExchange)
    end
    if data["res_type"] ~= nil then
        local reward = RewardInBound.CreateByParams(data)
        self.listReward:Add(reward)
    end
    if data["money_type"] ~= nil then
        local money = ItemIconData.CreateInstance(ResourceType.Money, tonumber(data["money_type"]), tonumber(data["money_value"]))
        self.listMoney:Add(money)
    end
end

--- @class EventExchangeConfig
EventExchangeConfig = Class(EventExchangeConfig)

--- @return void
function EventExchangeConfig:Ctor()
    ---@type Dictionary --<List<ExchangeData>>
    self.dict = Dictionary()
    self.dictType = Dictionary()
end

--- @return List
function EventExchangeConfig:GetDataFromCsv(csvPath)
    local listExchange = List()
    local type = 1
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(csvPath)
    ---@type ExchangeData
    local exchangeData
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.event_id ~= nil then
            type = data.event_id
        end
        if data.id ~= nil then
            exchangeData = ExchangeData()
            exchangeData:ParsedData(data)
            listExchange:Add(exchangeData)
        else
            exchangeData:AddData(data)
        end
    end
    return listExchange, type
end

--- @return List
function EventExchangeConfig:GetDataFromId(id)
    local listExchangeData = self.dict:Get(id)
    local type = self.dictType:Get(id)
    if listExchangeData == nil then
        listExchangeData, type = self:GetDataFromCsv(string.format(CSV_PATH, id))
        self.dict:Add(id, listExchangeData)
        self.dictType:Add(id, type)
    end
    return listExchangeData, type
end

return EventExchangeConfig