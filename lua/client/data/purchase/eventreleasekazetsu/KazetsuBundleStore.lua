local PATH = "csv/event/event_kazetsu/data_%d/limited_bundle_pack.csv"

--- @class KazetsuBundleStore : EventStore
KazetsuBundleStore = Class(KazetsuBundleStore, EventStore)

function KazetsuBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_KAZETSU
    --- @type OpCode
    self.opCode = OpCode.EVENT_KAZETSU_LIMITED_BUNDLE_PURCHASE
    --- @type string
    self.filePath = PATH
    --- @type EventKazetsuBundleProduct
    self.pack = EventKazetsuBundleProduct
end

--- @class EventKazetsuBundleProduct : EventProduct
EventKazetsuBundleProduct = Class(EventKazetsuBundleProduct, EventProduct)

function EventKazetsuBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_KAZETSU_LIMITED_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_KAZETSU
end