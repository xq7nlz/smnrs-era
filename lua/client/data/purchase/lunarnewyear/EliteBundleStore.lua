local PATH = "csv/event/event_lunar_new_year/data_%d/elite_bundle.csv"

--- @class EliteBundleStore : EventStore
EliteBundleStore = Class(EliteBundleStore, EventStore)

function EliteBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR_2022
    --- @type OpCode
    self.opCode = OpCode.EVENT_LUNAR_NEW_YEAR_ELITE_STORE_PURCHASE
    --- @type string
    self.filePath = PATH
    --- @type EventEliteBundleProduct
    self.pack = EventEliteBundleProduct
end

--- @class EventEliteBundleProduct : EventProduct
EventEliteBundleProduct = Class(EventEliteBundleProduct, EventProduct)

function EventEliteBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_LUNAR_NEW_YEAR_ELITE_STORE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR_2022
end