local EVENT_EASTER_DAILY_PURCHASE_PATH = "csv/event/event_easter/data_%d/bundle_pack/easter_bundle.csv"

--- @class EasterDailyBundleStore : EventStore
EasterDailyBundleStore = Class(EasterDailyBundleStore, EventStore)

function EasterDailyBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_EASTER_EGG
    --- @type OpCode
    self.opCode = OpCode.EVENT_EASTER_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_EASTER_DAILY_PURCHASE_PATH
    --- @type EasterDailyProduct
    self.pack = EasterDailyProduct
end

--- @class EasterDailyProduct : EventProduct
EasterDailyProduct = Class(EasterDailyProduct, EventProduct)

function EasterDailyProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_EASTER_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_EASTER_EGG
end