local EVENT_PATH = "csv/event/event_summer_day/data_%d/bundle_pack.csv"

--- @class SummerDayStore : EventStore
SummerDayStore = Class(SummerDayStore, EventStore)

function SummerDayStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_SUMMER_DAY
    --- @type OpCode
    self.opCode = OpCode.EVENT_SUMMER_DAY_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_PATH
    --- @type EventSummerDayProduct
    self.pack = EventSummerDayProduct
end

--- @class EventSummerDayProduct : EventProduct
EventSummerDayProduct = Class(EventSummerDayProduct, EventProduct)

function EventSummerDayProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_SUMMER_DAY_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_SUMMER_DAY
end