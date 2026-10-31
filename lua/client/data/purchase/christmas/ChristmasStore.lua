local EVENT_CHRISTMAS_PATH = "csv/event/event_christmas_2023/data_%d/special_offer.csv"

--- @class ChristmasStore : EventStore
ChristmasStore = Class(ChristmasStore, EventStore)

function ChristmasStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_CHRISTMAS
    --- @type OpCode
    self.opCode = OpCode.EVENT_CHRISTMAS_PURCHASE
    --- @type string
    self.filePath = EVENT_CHRISTMAS_PATH
    --- @type EventChristmasProduct
    self.pack = EventChristmasProduct
end

--- @class EventChristmasProduct : EventProduct
EventChristmasProduct = Class(EventChristmasProduct, EventProduct)

function EventChristmasProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_CHRISTMAS_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_CHRISTMAS
end