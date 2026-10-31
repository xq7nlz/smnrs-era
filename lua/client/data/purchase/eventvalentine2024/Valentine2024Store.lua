local EVENT_PATH = "csv/event/event_valentine_2024/data_%d/bundle_pack.csv"

--- @class Valentine2024Store : EventStore
Valentine2024Store = Class(Valentine2024Store, EventStore)

function Valentine2024Store:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_VALENTINE_2024
    --- @type OpCode
    self.opCode = OpCode.EVENT_VALENTINE_2024_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_PATH
    --- @type EventValentine2024Product
    self.pack = EventValentine2024Product
end

--- @class EventValentine2024Product : EventProduct
EventValentine2024Product = Class(EventValentine2024Product, EventProduct)

function EventValentine2024Product:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_VALENTINE_2024_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_VALENTINE_2024
end