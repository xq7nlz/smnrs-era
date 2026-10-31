require "lua.client.data.Purchase.Event.EventStore"
require "lua.client.data.Purchase.Event.EventProduct"

EVENT_ARENA_PATH_FORMAT = "csv/event/event_arena_pass/data_%d/arena_pass_pack.csv"

--- @class EventArenaPassProduct : EventProduct
EventArenaPassProduct = Class(EventArenaPassProduct, EventProduct)

function EventArenaPassProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_ARENA_PASS_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_ARENA_PASS
end

---------------------------------------------------------
--- @class EventArenaPassStore : EventStore
EventArenaPassStore = Class(EventArenaPassStore, EventStore)

--- @return void
function EventArenaPassStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_ARENA_PASS
    --- @type OpCode
    self.opCode = OpCode.EVENT_ARENA_PASS_PURCHASE
    --- @type string
    self.filePath = EVENT_ARENA_PATH_FORMAT
    --- @type EventArenaPassProduct
    self.pack = EventArenaPassProduct
end
