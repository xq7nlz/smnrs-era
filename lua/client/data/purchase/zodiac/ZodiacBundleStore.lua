local EVENT_ZODIAC_BUNDLE_PURCHASE_PATH = "csv/event/event_zodiac/data_%d/universe_bundle.csv"

--- @class ZodiacBundleStore : EventStore
ZodiacBundleStore = Class(ZodiacBundleStore, EventStore)

function ZodiacBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_ZODIAC
    --- @type OpCode
    self.opCode = OpCode.EVENT_ZODIAC_BUNDLE_PURCHASE_HANDLER
    --- @type string
    self.filePath = EVENT_ZODIAC_BUNDLE_PURCHASE_PATH
    --- @type ZodiacBundleProduct
    self.pack = ZodiacBundleProduct
end

--- @class ZodiacBundleProduct : EventProduct
ZodiacBundleProduct = Class(ZodiacBundleProduct, EventProduct)

function ZodiacBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_ZODIAC_BUNDLE_PURCHASE_HANDLER
    self.eventTimeType = EventTimeType.EVENT_ZODIAC
end