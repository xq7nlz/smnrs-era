local EVENT_EASTER_BUNDLE_CARD_PATH = "csv/event/event_easter/data_%d/bundle_pack/exclusive_bundle.csv"

--- @class EasterSkinBundleStore : EventStore
EasterSkinBundleStore = Class(EasterSkinBundleStore, EventStore)

function EasterSkinBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_EASTER_EGG
    --- @type OpCode
    self.opCode = OpCode.EVENT_EASTER_LIMIT_OFFER_PURCHASE
    --- @type string
    self.filePath = EVENT_EASTER_BUNDLE_CARD_PATH
    --- @type EasterSkinBundleProduct
    self.pack = EasterSkinBundleProduct
end

--[[--- @return boolean
function EasterSkinBundleStore:IsNotificationDailyDeal()
    local noti = false
    ---@type EventEasterEggModel
    local easterEggModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    --- @param v LimitedProduct
    for i, v in ipairs(self:GetCurrentPack().packList:GetItems()) do
        if v.isFree == true and easterEggModel:GetLimitedPackStatisticsInBound(v.id):GetNumberOfBought() < v.stock then
            noti = true
            break
        end
    end
    return noti
end]]

--- @class EasterSkinBundleProduct : EventProduct
EasterSkinBundleProduct = Class(EasterSkinBundleProduct, EventProduct)

function EasterSkinBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_EASTER_LIMIT_OFFER_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_EASTER_EGG
end