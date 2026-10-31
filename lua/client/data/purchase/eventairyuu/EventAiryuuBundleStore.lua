local EVENT_AIRYUU_BUNDLE_PACK_CONFIG_PATH = "csv/event/event_hero_airyuu/data_%d/limited_bundle_pack.csv"

--- @class EventAiryuuBundleStore : EventStore
EventAiryuuBundleStore = Class(EventAiryuuBundleStore, EventStore)

function EventAiryuuBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_AIRYUU
    --- @type OpCode
    self.opCode = OpCode.EVENT_HERO_AIRYUU_BUNDLE
    --- @type string
    self.filePath = EVENT_AIRYUU_BUNDLE_PACK_CONFIG_PATH
    --- @type EventAiryuuBundleProduct
    self.pack = EventAiryuuBundleProduct
end

--- @class EventAiryuuBundleProduct : EventProduct
EventAiryuuBundleProduct = Class(EventAiryuuBundleProduct, EventProduct)

function EventAiryuuBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_HERO_AIRYUU_BUNDLE
    self.eventTimeType = EventTimeType.EVENT_AIRYUU
end