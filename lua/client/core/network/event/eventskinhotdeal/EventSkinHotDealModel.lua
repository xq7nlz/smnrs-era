--- @class EventSkinHotDealModel : EventPopupModel
EventSkinHotDealModel = Class(EventSkinHotDealModel, EventPopupModel)

function EventSkinHotDealModel:Ctor()
    --- @type Dictionary
    self.numberBuyDataDict = Dictionary()

    EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventSkinHotDealModel:ReadInnerData(buffer)
    self.numberBuyDataDict = Dictionary()
    local size = buffer:GetByte()
    for i = 1, size do
        local numberBuyData = NumberBuyData()
        numberBuyData:ReadBuffer(buffer)
        self.numberBuyDataDict:Add(i, numberBuyData)
    end
end

--- @return EventSkinHotDealConfig
function EventSkinHotDealModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @return PurchasedPackInBound
--- @param packId number
function EventSkinHotDealModel:GetPurchasePackInBound(packId)
    for i = 1, self.listPurchasePack:Count() do
        --- @type PurchasedPackInBound
        local itemData = self.listPurchasePack:Get(i)
        if itemData.packId == packId then
            return itemData
        end
    end
    local default = PurchasedPackInBound()
    default.packId = packId
    local config = self:GetConfig():GetPackBase(packId)
    default:SetConfig(config)
    self.listPurchasePack:Add(default)
    return default
end

function EventSkinHotDealModel:OnPurchaseSuccess(packId)
    local purchasedPackInBound = self:GetPurchasePackInBound(packId)
    purchasedPackInBound:IncreaseNumberOfBought()
end

--- @param opCode OpCode
--- @param packId number
function EventSkinHotDealModel:GetNumberBuyOpCode(opCode, packId)
    return self:GetPurchasePackInBound(packId).numberOfBought
end

--- @param opCode OpCode
--- @param packId number
function EventSkinHotDealModel:AddNumberBuyOpCode(opCode, packId, number)
    self:OnPurchaseSuccess(packId)
end