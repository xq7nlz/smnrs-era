local EVENT_BUNDLE_PACK_CONFIG_PATH = "csv/event/event_seasonal/data_%d/limited_bundle_pack.csv"

--- @class EventSeasonalBundleStore : EventStore
EventSeasonalBundleStore = Class(EventSeasonalBundleStore, EventStore)

function EventSeasonalBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_SEASONAL
    --- @type OpCode
    self.opCode = OpCode.EVENT_SEASONAL_BUNDLE
    --- @type string
    self.filePath = EVENT_BUNDLE_PACK_CONFIG_PATH
    --- @type EventSeasonalBundleProduct
    self.pack = EventSeasonalBundleProduct
end

--- @class EventSeasonalBundleProduct : EventProduct
EventSeasonalBundleProduct = Class(EventSeasonalBundleProduct, EventProduct)

function EventSeasonalBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_SEASONAL_BUNDLE
    self.eventTimeType = EventTimeType.EVENT_SEASONAL
end