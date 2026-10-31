local PATH = "csv/event/event_new_hero_skin_bundle/data_%d/skin_bundle_pack.csv"

--- @class NewHeroSkinBundleStore : EventStore
NewHeroSkinBundleStore = Class(NewHeroSkinBundleStore, EventStore)

function NewHeroSkinBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_NEW_HERO_SKIN_BUNDLE
    --- @type OpCode
    self.opCode = OpCode.EVENT_NEW_HERO_SKIN_BUNDLE_PURCHASE
    --- @type string
    self.filePath = PATH
    --- @type EventEliteBundleProduct
    self.pack = EventEliteBundleProduct
end

--- @class EventNewHeroSkinBundleProduct : EventProduct
EventNewHeroSkinBundleProduct = Class(EventEliteBundleProduct, EventProduct)

function EventNewHeroSkinBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.eventTimeType = EventTimeType.EVENT_NEW_HERO_SKIN_BUNDLE
    self.opCode = OpCode.EVENT_NEW_HERO_SKIN_BUNDLE_PURCHASE
end