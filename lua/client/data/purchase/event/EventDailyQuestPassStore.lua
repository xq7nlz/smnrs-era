require "lua.client.data.Purchase.Event.EventStore"
require "lua.client.data.Purchase.Event.EventProduct"

EVENT_DAILY_QUEST_PASS_PATH_FORMAT = "csv/event/event_daily_quest_pass/data_%d/daily_quest_pass_pack.csv"

--- @class EventDailyQuestPassProduct : EventProduct
EventDailyQuestPassProduct = Class(EventDailyQuestPassProduct, EventProduct)

function EventDailyQuestPassProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_DAILY_QUEST_PASS_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_DAILY_QUEST_PASS
end

---------------------------------------------------------
--- @class EventDailyQuestPassStore : EventStore
EventDailyQuestPassStore = Class(EventDailyQuestPassStore, EventStore)

--- @return void
function EventDailyQuestPassStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_DAILY_QUEST_PASS
    --- @type OpCode
    self.opCode = OpCode.EVENT_DAILY_QUEST_PASS_PURCHASE
    --- @type string
    self.filePath = EVENT_DAILY_QUEST_PASS_PATH_FORMAT
    --- @type EventDailyQuestPassProduct
    self.pack = EventDailyQuestPassProduct
end
