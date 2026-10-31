local EVENT_MID_AUTUMN_PATH = "csv/event/event_mid_autumn/data_%d/special_offer.csv"

--- @class MidAutumnStore : EventStore
MidAutumnStore = Class(MidAutumnStore, EventStore)

function MidAutumnStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_MID_AUTUMN
    --- @type OpCode
    self.opCode = OpCode.EVENT_MID_AUTUMN_PURCHASE
    --- @type string
    self.filePath = EVENT_MID_AUTUMN_PATH
    --- @type EventMidAutumnProduct
    self.pack = EventMidAutumnProduct
end

--- @class EventMidAutumnProduct : EventProduct
EventMidAutumnProduct = Class(EventMidAutumnProduct, EventProduct)

function EventMidAutumnProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_MID_AUTUMN_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_MID_AUTUMN
end