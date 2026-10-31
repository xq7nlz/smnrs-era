local EVENT_PATH = "csv/event/event_may_day/data_%d/bundle_pack.csv"

--- @class MayDayStore : EventStore
MayDayStore = Class(MayDayStore, EventStore)

function MayDayStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_MAY_DAY
    --- @type OpCode
    self.opCode = OpCode.EVENT_MAY_DAY_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_PATH
    --- @type EventMayDayProduct
    self.pack = EventMayDayProduct
end

--- @class EventMayDayProduct : EventProduct
EventMayDayProduct = Class(EventMayDayProduct, EventProduct)

function EventMayDayProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_MAY_DAY_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_MAY_DAY
end