--- @class EventSkinBundleModel : EventPopupModel
EventSkinBundleModel = Class(EventSkinBundleModel, EventPopupModel)

function EventSkinBundleModel:Ctor()
    --- @type List
    self.listPurchasePack = List()

    EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventSkinBundleModel:ReadInnerData(buffer)
    --- @type List
    self.listPurchasePack = NetworkUtils.GetListDataInBound(buffer, PurchasedPackInBound.CreateByBuffer)
    for i = 1, self.listPurchasePack:Count() do
        --- @type PurchasedPackInBound
        local purchasedPackInBound = self.listPurchasePack:Get(i)
        local config = self:GetConfig():GetPackBase(purchasedPackInBound.packId)
        purchasedPackInBound:SetConfig(config)
    end
end

--- @return PackOfProducts
function EventSkinBundleModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @return PurchasedPackInBound
--- @param packId number
function EventSkinBundleModel:GetPurchasePackInBound(packId)
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

function EventSkinBundleModel:OnPurchaseSuccess(packId)
    local purchasedPackInBound = self:GetPurchasePackInBound(packId)
    purchasedPackInBound:IncreaseNumberOfBought()
end

--- @param opCode OpCode
--- @param packId number
function EventSkinBundleModel:GetNumberBuyOpCode(opCode, packId)
    return self:GetPurchasePackInBound(packId).numberOfBought
end

--- @param opCode OpCode
--- @param packId number
function EventSkinBundleModel:AddNumberBuyOpCode(opCode, packId, number)
    self:OnPurchaseSuccess(packId)
end

--- @class UIEventSkinBundleTab
UIEventSkinBundleTab = {
    BUNDLE = 1,
    SKINS = 2,
}