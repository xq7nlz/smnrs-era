local EVENT_LUNAR_PATH_SPRING_BUNDLE = "csv/event/event_lunar_new_year_2022/data_%d/bundle_pack/spring_bundle_pack.csv"

--- @class LunarSpringBundleStore : EventStore
LunarSpringBundleStore = Class(LunarSpringBundleStore, EventStore)

function LunarSpringBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR_2022
    --- @type OpCode
    self.opCode = OpCode.EVENT_LUNAR_2022_SPRING_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_LUNAR_PATH_SPRING_BUNDLE
    --- @type EventLunarSpringProduct
    self.pack = EventLunarSpringProduct
end

--- @class EventLunarSpringProduct : EventProduct
EventLunarSpringProduct = Class(EventLunarSpringProduct, EventProduct)

function EventLunarSpringProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_LUNAR_2022_SPRING_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR_2022
end