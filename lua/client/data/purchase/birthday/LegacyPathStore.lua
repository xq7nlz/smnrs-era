require "lua.client.data.Purchase.Event.EventStore"
require "lua.client.data.Purchase.Event.EventProduct"

local EVENT_LEGACY_PATH_FORMAT = "csv/event/event_birthday/data_%d/legacy_path/legacy_path_pack.csv"

--- @class LegacyPathProduct : EventProduct
LegacyPathProduct = Class(LegacyPathProduct, EventProduct)

function LegacyPathProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_BIRTHDAY_LEGACY_PATH_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_BIRTHDAY
    --- @type List
    self.rewardPool = List()
end

---------------------------------------------------------
--- @class LegacyPathStore : EventStore
LegacyPathStore = Class(LegacyPathStore, EventStore)

--- @return void
function LegacyPathStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BIRTHDAY
    --- @type OpCode
    self.opCode = OpCode.EVENT_BIRTHDAY_LEGACY_PATH_PURCHASE
    --- @type string
    self.filePath = EVENT_LEGACY_PATH_FORMAT
    --- @type LegacyPathProduct
    self.pack = LegacyPathProduct
end
