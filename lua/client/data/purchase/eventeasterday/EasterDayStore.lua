local EVENT_PATH = "csv/event/event_easter_egg/data_%d/bundle_pack.csv"

--- @class EasterDayStore : EventStore
EasterDayStore = Class(EasterDayStore, EventStore)

function EasterDayStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_EASTER_DAY
    --- @type OpCode
    self.opCode = OpCode.EVENT_EASTERS_EGG_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_PATH
    --- @type EventEasterDayProduct
    self.pack = EventEasterDayProduct
end

--- @class EventEasterDayProduct : EventProduct
EventEasterDayProduct = Class(EventEasterDayProduct, EventProduct)

function EventEasterDayProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_EASTERS_EGG_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_EASTER_DAY
end