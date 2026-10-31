local EVENT_XMAS_PATH = "csv/event/event_christmas/data_%d/exclusive_offer.csv"

--- @class XmasExclusiveStore : EventStore
XmasExclusiveStore = Class(XmasExclusiveStore, EventStore)

function XmasExclusiveStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_XMAS
    --- @type OpCode
    self.opCode = OpCode.EVENT_CHRISTMAS_EXCLUSIVE_OFFER_PURCHASE
    --- @type string
    self.filePath = EVENT_XMAS_PATH
    --- @type EventXmasProduct
    self.pack = EventXmasProduct
end

--- @class EventXmasProduct : EventProduct
EventXmasProduct = Class(EventXmasProduct, EventProduct)

function EventXmasProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_CHRISTMAS_EXCLUSIVE_OFFER_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_XMAS
end