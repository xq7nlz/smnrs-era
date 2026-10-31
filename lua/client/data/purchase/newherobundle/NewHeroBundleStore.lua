local PATH = "csv/event/event_new_hero_bundle/data_%d/bundle_pack.csv"

--- @class NewHeroBundleStore : EventStore
NewHeroBundleStore = Class(NewHeroBundleStore, EventStore)

function NewHeroBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_NEW_HERO_BUNDLE
    --- @type OpCode
    self.opCode = OpCode.EVENT_NEW_HERO_BUNDLE_PURCHASE
    --- @type string
    self.filePath = PATH
    --- @type EventEliteBundleProduct
    self.pack = EventEliteBundleProduct
end

--- @class EventNewHeroBundleProduct : EventProduct
EventNewHeroBundleProduct = Class(EventEliteBundleProduct, EventProduct)

function EventNewHeroBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_NEW_HERO_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_NEW_HERO_BUNDLE
end