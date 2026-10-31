local EVENT_BLACK_FRIDAY_PATH = "csv/event/event_black_friday/data_%d/bundle_pack.csv"

--- @class BlackFridayGemPackStore : EventStore
BlackFridayGemPackStore = Class(BlackFridayGemPackStore, EventStore)

function BlackFridayGemPackStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BLACK_FRIDAY
    --- @type OpCode
    self.opCode = OpCode.EVENT_BLACK_FRIDAY_GEM_PACK_BUY
    --- @type string
    self.filePath = EVENT_BLACK_FRIDAY_PATH
    --- @type EventBackFridayGemPackProduct
    self.pack = EventBackFridayGemPackProduct
end

--- @class EventBackFridayGemPackProduct : EventProduct
EventBackFridayGemPackProduct = Class(EventBackFridayGemPackProduct, EventProduct)

function EventBackFridayGemPackProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_BLACK_FRIDAY_GEM_PACK_BUY
    self.eventTimeType = EventTimeType.EVENT_BLACK_FRIDAY
end