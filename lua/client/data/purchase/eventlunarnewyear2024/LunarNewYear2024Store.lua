local EVENT_PATH = "csv/event/event_lunar_new_year_2024/data_%d/bundle_pack.csv"

--- @class LunarNewYear2024Store : EventStore
LunarNewYear2024Store = Class(LunarNewYear2024Store, EventStore)

function LunarNewYear2024Store:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR_2024
    --- @type OpCode
    self.opCode = OpCode.EVENT_LUNAR_NEW_YEAR_2024_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_PATH
    --- @type EventLunarNewYear2024Product
    self.pack = EventLunarNewYear2024Product
end

--- @class EventLunarNewYear2024Product : EventProduct
EventLunarNewYear2024Product = Class(EventLunarNewYear2024Product, EventProduct)

function EventLunarNewYear2024Product:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_LUNAR_NEW_YEAR_2024_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR_2024
end