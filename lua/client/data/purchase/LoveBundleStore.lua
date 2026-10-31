local PATH = "csv/event/event_valentine/data_%d/love_challenge_bundle.csv"

--- @class LoveBundleStore : EventStore
LoveBundleStore = Class(LoveBundleStore, EventStore)

function LoveBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_VALENTINE
    --- @type OpCode
    self.opCode = OpCode.EVENT_VALENTINE_LOVE_BUNDLE_PURCHASE
    --- @type string
    self.filePath = PATH
    --- @type EventLoveBundleProduct
    self.pack = EventLoveBundleProduct
end

--- @class EventLoveBundleProduct : EventProduct
EventLoveBundleProduct = Class(EventLoveBundleProduct, EventProduct)

function EventLoveBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_VALENTINE_LOVE_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_VALENTINE
end