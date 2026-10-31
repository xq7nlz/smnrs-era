local EVENT_BUNDLE_PACK_CONFIG_PATH = "csv/event/event_dragon_tower/data_%d/event_bundle.csv"

--- @class EventTowerOfEitriBundleStore : EventStore
EventTowerOfEitriBundleStore = Class(EventTowerOfEitriBundleStore, EventStore)

function EventTowerOfEitriBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_TOWER_OF_EITRI
    --- @type OpCode
    self.opCode = OpCode.EVENT_DRAGON_TOWER_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_BUNDLE_PACK_CONFIG_PATH
    --- @type EventTowerOfEitriBundleProduct
    self.pack = EventTowerOfEitriBundleProduct
end

--- @class EventTowerOfEitriBundleProduct : EventProduct
EventTowerOfEitriBundleProduct = Class(EventTowerOfEitriBundleProduct, EventProduct)

function EventTowerOfEitriBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_DRAGON_TOWER_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_TOWER_OF_EITRI
end