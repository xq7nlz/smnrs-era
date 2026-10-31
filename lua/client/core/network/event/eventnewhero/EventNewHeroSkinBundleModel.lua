--- @class EventNewHeroSkinBundleModel : EventPopupModel
EventNewHeroSkinBundleModel = Class(EventNewHeroSkinBundleModel, EventPopupModel)

function EventNewHeroSkinBundleModel:Ctor()
    --- @type List
    self.listPurchasePack = List()

    EventPopupModel.Ctor(self)
end

function EventNewHeroSkinBundleModel:ReadInnerData(buffer)
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
function EventNewHeroSkinBundleModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @return PurchasedPackInBound
--- @param packId number
function EventNewHeroSkinBundleModel:GetPurchasePackInBound(packId)
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

function EventNewHeroSkinBundleModel:OnPurchaseSuccess(packId)
    local purchasedPackInBound = self:GetPurchasePackInBound(packId)
    purchasedPackInBound:IncreaseNumberOfBought()
end

function EventNewHeroSkinBundleModel:GetNumberBuyOpCode(opCode, packId)
    return self:GetPurchasePackInBound(packId).numberOfBought
end

--- @param opCode OpCode
--- @param packId number
function EventNewHeroSkinBundleModel:AddNumberBuyOpCode(opCode, packId, number)
    for i = 1, self.listPurchasePack:Count() do
        --- @type PurchasedPackInBound
        local itemData = self.listPurchasePack:Get(i)
        if itemData.packId == packId then
            itemData:IncreaseNumberOfBought(number)
        end
    end
end