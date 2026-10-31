--- @class EventPopupPurchaseModel : EventPopupModel
EventPopupPurchaseModel = Class(EventPopupPurchaseModel, EventPopupModel)

function EventPopupPurchaseModel:Ctor()
    EventPopupModel.Ctor(self)
    --- @type Dictionary
    self.dataDict = Dictionary()
end

function EventPopupPurchaseModel:ReadInnerData(buffer)
    local size = buffer:GetByte()
    if size > 0 then
        for _ = 1, size do
            local data = PurchasedPackInBound.CreateByBuffer(buffer)
            data:SetConfig(self:GetConfig():GetPackBase(data.packId))
            self.dataDict:Add(data.packId, data)
        end
    end
    for key, productConfig in pairs(self:GetConfig():GetAllPackDict():GetItems()) do
        if self.dataDict:IsContainKey(key) == false then
            local purchasePack = PurchasedPackInBound()
            purchasePack.packId = key
            purchasePack:SetConfig(productConfig)
            self.dataDict:Add(key, purchasePack)
        end
    end
end

--- @return QuestUnitInBound|PurchasedPackInBound
function EventPopupPurchaseModel:GetData(id)
    local data = self.dataDict:Get(id)
    if data == nil then
        XDebug.Error(string.format("data_id is nil: %s", id))
    end
    return data
end

--- @return Dictionary
function EventPopupPurchaseModel:GetAllData()
    return self.dataDict
end

function EventPopupPurchaseModel:HasNotification()
    --- @type PackOfProducts
    local config = self:GetConfig()
    --- @param productConfig LimitedProduct
    for key, productConfig in pairs(config:GetAllPackBase():GetItems()) do
        if productConfig.isFree == true then
            --- @type PurchasedPackInBound
            local purchasedPackInBound = self.dataDict:Get(key)
            if purchasedPackInBound ~= nil and productConfig.stock - purchasedPackInBound.numberOfBought > 0 then
                return true
            end
        end
    end
    return false
end