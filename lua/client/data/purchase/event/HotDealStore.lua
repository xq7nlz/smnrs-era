require "lua.client.data.Purchase.Event.EventStore"
require "lua.client.data.Purchase.Event.EventProduct"

local EVENT_HOT_DEAL_PATH = "csv/event/event_hot_deal/data_%d/hot_deal_pack.csv"

--- @class HotDealProduct : ProductConfig
HotDealProduct = Class(HotDealProduct, EventProduct)

function HotDealProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_HOT_DEAL_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_HOT_DEAL
end

--- @class HotDealStore : EventStore
HotDealStore = Class(HotDealStore, EventStore)

--- @return void
function HotDealStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_HOT_DEAL
    --- @type OpCode
    self.opCode = OpCode.EVENT_HOT_DEAL_PURCHASE
    --- @type string
    self.filePath = EVENT_HOT_DEAL_PATH
    --- @type HotDealProduct
    self.pack = HotDealProduct
end