local SKIN_BUNDLE_PATH = "csv/event/event_skin_bundle/data_%d/skin_bundle_pack.csv"

--- @class SkinBundleStore : EventStore
SkinBundleStore = Class(SkinBundleStore, EventStore)

function SkinBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_SKIN_BUNDLE
    --- @type OpCode
    self.opCode = OpCode.EVENT_SKIN_BUNDLE_PURCHASE
    --- @type string
    self.filePath = SKIN_BUNDLE_PATH
    --- @type EventSkinBundleProduct
    self.pack = EventSkinBundleProduct
end

--- @class EventSkinBundleProduct : EventProduct
EventSkinBundleProduct = Class(EventSkinBundleProduct, EventProduct)

function EventSkinBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_SKIN_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_SKIN_BUNDLE
end