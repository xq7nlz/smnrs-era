local EVENT_PATH = "csv/event/event_thanks_giving/data_%d/bundle_pack.csv"

--- @class ThanksGivingStore : EventStore
ThanksGivingStore = Class(ThanksGivingStore, EventStore)

function ThanksGivingStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_THANKS_GIVING
    --- @type OpCode
    self.opCode = OpCode.EVENT_THANKS_GIVING_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_PATH
    --- @type EventThanksGivingProduct
    self.pack = EventThanksGivingProduct
end

--- @class EventThanksGivingProduct : EventProduct
EventThanksGivingProduct = Class(EventThanksGivingProduct, EventProduct)

function EventThanksGivingProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_THANKS_GIVING_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_THANKS_GIVING
end