local SKIN_BUNDLE_HOT_PACK = "csv/event/event_skin_hot_deal/data_%d/skin_bundle_pack.csv"

--- @class EventSkinHotDealStore : EventStore
EventSkinHotDealStore = Class(EventSkinHotDealStore, EventStore)

function EventSkinHotDealStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_SKIN_HOT_DEAL
    --- @type OpCode
    self.opCode = OpCode.EVENT_SKIN_HOT_DEAL_PURCHASE
    --- @type string
    self.filePath = SKIN_BUNDLE_HOT_PACK
    --- @type EventSkinHotDealProduct
    self.pack = EventSkinHotDealProduct
end

--- @class EventSkinHotDealProduct : EventProduct
EventSkinHotDealProduct = Class(EventSkinHotDealProduct, EventProduct)

function EventSkinHotDealProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_SKIN_HOT_DEAL_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_SKIN_HOT_DEAL
end