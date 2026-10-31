local EVENT_PATH = "csv/event/event_new_year_2023/data_%d/bundle_pack.csv"

--- @class NewYear2023Store : EventStore
NewYear2023Store = Class(NewYear2023Store, EventStore)

function NewYear2023Store:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_NEW_YEAR_2023
    --- @type OpCode
    self.opCode = OpCode.EVENT_NEW_YEAR_2023_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_PATH
    --- @type EventNewYear2023Product
    self.pack = EventNewYear2023Product
end

--- @class EventNewYear2023Product : EventProduct
EventNewYear2023Product = Class(EventNewYear2023Product, EventProduct)

function EventNewYear2023Product:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_NEW_YEAR_2023_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_NEW_YEAR_2023
end