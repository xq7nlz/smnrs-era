local EVENT_PATH = "csv/event/event_blossom_day/data_%d/bundle_pack.csv"

--- @class BlossomDayStore : EventStore
BlossomDayStore = Class(BlossomDayStore, EventStore)

function BlossomDayStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BLOSSOM
    --- @type OpCode
    self.opCode = OpCode.EVENT_BLOSSOM_DAY_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_PATH
    --- @type EventBlossomDayProduct
    self.pack = EventBlossomDayProduct
end

--- @class EventBlossomDayProduct : EventProduct
EventBlossomDayProduct = Class(EventBlossomDayProduct, EventProduct)

function EventBlossomDayProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_BLOSSOM_DAY_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_BLOSSOM
end