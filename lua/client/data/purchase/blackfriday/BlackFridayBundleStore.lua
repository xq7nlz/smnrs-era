local EVENT_BLACK_FRIDAY_PATH = "csv/event/event_black_friday/data_%d/bundle_pack.csv"

--- @class BlackFridayBundleStore : EventStore
BlackFridayBundleStore = Class(BlackFridayBundleStore, EventStore)

function BlackFridayBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BLACK_FRIDAY
    --- @type OpCode
    self.opCode = OpCode.EVENT_BLACK_FRIDAY_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_BLACK_FRIDAY_PATH
    --- @type EventBackFridayBundleProduct
    self.pack = EventBackFridayBundleProduct
end

--- @class EventBackFridayBundleProduct : EventProduct
EventBackFridayBundleProduct = Class(EventBackFridayBundleProduct, EventProduct)

function EventBackFridayBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_BLACK_FRIDAY_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_BLACK_FRIDAY
end