local EVENT_HALLOWEEN_PATH = "csv/event/event_halloween/data_%d/bundle_pack.csv"

--- @class HalloweenStore : EventStore
HalloweenStore = Class(HalloweenStore, EventStore)

function HalloweenStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_HALLOWEEN
    --- @type OpCode
    self.opCode = OpCode.EVENT_HALLOWEEN_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_HALLOWEEN_PATH
    --- @type EventHalloweenProduct
    self.pack = EventHalloweenProduct
end

--- @class EventHalloweenProduct : EventProduct
EventHalloweenProduct = Class(EventHalloweenProduct, EventProduct)

function EventHalloweenProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_HALLOWEEN_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_HALLOWEEN
end