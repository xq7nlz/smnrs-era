local EVENT_LUNAR_PATH_BUNDLE = "csv/event/event_lunar_new_year/data_%d/skin_bundle.csv"

--- @class LunarSkinBundle : EventStore
LunarSkinBundle = Class(LunarSkinBundle, EventStore)

function LunarSkinBundle:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR
    --- @type OpCode
    self.opCode = OpCode.EVENT_LUNAR_ELITE_SKIN_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_LUNAR_PATH_BUNDLE
    --- @type EventLunarSkinBundleProduct
    self.pack = EventLunarSkinBundleProduct
end

--- @class EventLunarSkinBundleProduct : EventProduct
EventLunarSkinBundleProduct = Class(EventLunarSkinBundleProduct, EventProduct)

function EventLunarSkinBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_LUNAR_ELITE_SKIN_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR
end