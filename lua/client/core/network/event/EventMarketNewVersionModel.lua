--- @class EventMarketNewVersionModel : EventPopupModel
EventMarketNewVersionModel = Class(EventMarketNewVersionModel, EventPopupModel)

local TOTAL_NUMBER_DATA = 8

function EventMarketNewVersionModel:Ctor()
    EventPopupModel.Ctor(self)
    ---@type number
    self.dataId = nil
    ---@type Dictionary
    self.dictNumberBuy = Dictionary()
    ---@type Dictionary
    self.dictNumberBuyItem = Dictionary()
    ---@type EventMarketNewVersionConfig
    self.config = nil
end

--- @return EventMarketNewVersionConfig
function EventMarketNewVersionModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventMarketNewVersionModel:ReadInnerData(buffer)
    self.config = self:GetConfig()
    self.dataId = buffer:GetInt()
    for _ = 1, buffer:GetByte() do
        --- @type EventActionType
        local dataId = buffer:GetByte()
        local numberBuyData = NumberBuyData()
        numberBuyData:ReadBuffer(buffer)
        self.dictNumberBuy:Add(dataId, numberBuyData)
    end

    for _ = 1, buffer:GetByte() do
        --- @type EventActionType
        local dataId = buffer:GetByte()
        local numberBuyItemData = NumberBuyData()
        numberBuyItemData:ReadBuffer(buffer)
        self.dictNumberBuyItem:Add(dataId, numberBuyItemData)
    end
    self.marketItemList = self:GetMarketItemListByDataId()
    self:ValidateMarketItemList()
end

function EventMarketNewVersionModel:ValidateMarketItemList()
    ---@param item MarketItemInBound
    for _, item in pairs(self.marketItemList:GetItems()) do
        local numberBuyData = self:GetNumberBuyMarketItem(item.id)
        item.numberItemCanBuy = item.maxItem - numberBuyData
        if item.numberItemCanBuy < 0 then
            item.numberItemCanBuy = 0
        end

        local numberBoughtItem = self:GetNumberBoughtMarketItem(item.id)
        if numberBoughtItem > 4 then
            numberBoughtItem = 4
        end
        item.cost.value = self.config:GetDictPriceValueItem():Get(numberBoughtItem)
    end
end

function EventMarketNewVersionModel:ResetNumberBuyMarketItem()
    ---@type NumberBuyData
    local numberBuyData = self.dictNumberBuy:Get(self.dataId)
    numberBuyData:ResetNumberBuyMarketItem()
end

function EventMarketNewVersionModel:AddNumberBuyMarketItem(id)
    ---@type NumberBuyData
    local numberBuyData = self.dictNumberBuy:Get(self.dataId)
    numberBuyData:AddNumberBoughtWithPackId(id)
end

function EventMarketNewVersionModel:AddNumberBoughtMarketItem(id)
    ---@type NumberBuyData
    local numberBuyData = self.dictNumberBuyItem:Get(self.dataId)
    numberBuyData:AddNumberBoughtWithPackId(id)
end

function EventMarketNewVersionModel:GetNumberBuyMarketItem(id, dataId)
    local keyId = dataId or self.dataId
    if self.dictNumberBuy:IsContainKey(keyId) then
        ---@type NumberBuyData
        local numberBuyData = self.dictNumberBuy:Get(keyId)
        return numberBuyData.buyStatsDict:GetOrDefault(id, 0)
    else
        local numberBuyData = NumberBuyData()
        numberBuyData.buyStatsDict:Add(id, 0)
        self.dictNumberBuy:Add(keyId, numberBuyData)
        return 0
    end
end

function EventMarketNewVersionModel:GetNumberBoughtMarketItem(id, dataId)
    local keyId = dataId or self.dataId
    if self.dictNumberBuyItem:IsContainKey(keyId) then
        ---@type NumberBuyData
        local numberBuyData = self.dictNumberBuyItem:Get(keyId)
        return numberBuyData.buyStatsDict:GetOrDefault(id, 0)
    else
        local numberBuyData = NumberBuyData()
        numberBuyData.buyStatsDict:Add(id, 0)
        self.dictNumberBuyItem:Add(keyId, numberBuyData)
        return 0
    end
end

function EventMarketNewVersionModel:SetMarketItemList()
    self.marketItemList = self.config:GetListMarketItem(self.dataId)
end

---@return List
function EventMarketNewVersionModel:GetMarketItemList()
    return self.marketItemList
end

---@return List
function EventMarketNewVersionModel:GetMarketItemListByDataId(dataId)
    self.dataId = dataId or self.dataId
    self:SetMarketItemList()
    self:ValidateMarketItemList()
    return self.marketItemList
end

---@return List
function EventMarketNewVersionModel:GetRemainDataCanBuy()
    local numberRemain = 0
    local remainDataId
    for i = 1, TOTAL_NUMBER_DATA do
        local listItem = self.config:GetListMarketItem(i)
        ---@param v MarketItemInBound
        for _, v in pairs(listItem:GetItems()) do
            local numberBuy = self:GetNumberBuyMarketItem(v.id, i)
            v.numberItemCanBuy = v.maxItem - numberBuy
            if v.numberItemCanBuy > 0 then
                numberRemain = numberRemain + 1
                remainDataId = i
                break
            end
        end
    end
    return numberRemain, remainDataId
end

---@return List
function EventMarketNewVersionModel:CanRefreshDataId()
    local numberRemain, remainDataId = self:GetRemainDataCanBuy()
    if numberRemain > 1 then
        return true
    elseif numberRemain > 0 and remainDataId and remainDataId ~= self.dataId then
        return true
    end
    return false
end