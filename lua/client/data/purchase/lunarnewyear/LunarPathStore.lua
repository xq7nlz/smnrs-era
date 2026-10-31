local EVENT_LUNAR_PATH_BUNDLE = "csv/event/event_lunar_path/data_%d/lunar_path_bundle.csv"

--- @class LunarPathStore : EventStore
LunarPathStore = Class(LunarPathStore, EventStore)

function LunarPathStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR
    --- @type OpCode
    self.opCode = OpCode.EVENT_LUNAR_NEW_YEAR_LUNAR_PATH_STORE_PURCHASE
    --- @type string
    self.filePath = EVENT_LUNAR_PATH_BUNDLE
    --- @type EventLunarPathProduct
    self.pack = EventLunarPathProduct
end

--- @class EventLunarPathProduct : EventProduct
EventLunarPathProduct = Class(EventLunarPathProduct, EventProduct)

function EventLunarPathProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_LUNAR_NEW_YEAR_LUNAR_PATH_STORE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR
end