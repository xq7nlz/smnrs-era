require "lua.client.data.Purchase.Event.EventStore"
require "lua.client.data.Purchase.Event.EventProduct"

local EVENT_ARENA_PATH_FORMAT = "csv/event/event_lunar_new_year_2022/data_%d/tiger_path/tiger_path_pack.csv"

--- @class TigerPathProduct : EventProduct
TigerPathProduct = Class(TigerPathProduct, EventProduct)

function TigerPathProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_LUNAR_2022_TIGER_PATH_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR_2022
    --- @type List
    self.rewardPool = List()
end

---------------------------------------------------------
--- @class TigerPathStore : EventStore
TigerPathStore = Class(TigerPathStore, EventStore)

--- @return void
function TigerPathStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR_2022
    --- @type OpCode
    self.opCode = OpCode.EVENT_LUNAR_2022_TIGER_PATH_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_ARENA_PATH_FORMAT
    --- @type TigerPathProduct
    self.pack = TigerPathProduct
end
