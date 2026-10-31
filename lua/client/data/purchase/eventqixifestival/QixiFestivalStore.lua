local EVENT_PATH = "csv/event/event_qixi/data_%d/bundle_pack.csv"

--- @class QixiFestivalStore : EventStore
QixiFestivalStore = Class(QixiFestivalStore, EventStore)

function QixiFestivalStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_QIXI
    --- @type OpCode
    self.opCode = OpCode.EVENT_QIXI_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_PATH
    --- @type EventQixiFestivalProduct
    self.pack = EventQixiFestivalProduct
end

--- @class EventQixiFestivalProduct : EventProduct
EventQixiFestivalProduct = Class(EventQixiFestivalProduct, EventProduct)

function EventQixiFestivalProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_QIXI_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_QIXI
end