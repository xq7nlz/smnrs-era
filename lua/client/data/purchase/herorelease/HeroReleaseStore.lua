local PATH = "csv/event/event_new_hero_release/data_%d/bundle_pack.csv"

--- @class HeroReleaseStore : EventStore
HeroReleaseStore = Class(HeroReleaseStore, EventStore)

function HeroReleaseStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_HERO_RELEASE
    --- @type OpCode
    self.opCode = OpCode.EVENT_HERO_RELEASE_BUNDLE_PURCHASE
    --- @type string
    self.filePath = PATH
    --- @type EventHeroReleaseProduct
    self.pack = EventHeroReleaseProduct
end

--- @class EventHeroReleaseProduct : EventProduct
EventHeroReleaseProduct = Class(EventHeroReleaseProduct, EventProduct)

function EventHeroReleaseProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_HERO_RELEASE_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_HERO_RELEASE
end