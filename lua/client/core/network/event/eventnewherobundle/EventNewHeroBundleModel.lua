--- @class EventNewHeroBundleModel : EventPopupModel
EventNewHeroBundleModel = Class(EventNewHeroBundleModel, EventPopupModel)

function EventNewHeroBundleModel:Ctor()
    --- @type List
    self.listPurchasePack = List()

    EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventNewHeroBundleModel:ReadInnerData(buffer)
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
function EventNewHeroBundleModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @return PurchasedPackInBound
--- @param packId number
function EventNewHeroBundleModel:GetPurchasePackInBound(packId)
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

function EventNewHeroBundleModel:OnPurchaseSuccess(packId)
    local purchasedPackInBound = self:GetPurchasePackInBound(packId)
    purchasedPackInBound:IncreaseNumberOfBought()
end