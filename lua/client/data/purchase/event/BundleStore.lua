require "lua.client.data.Purchase.Event.EventStore"
require "lua.client.data.Purchase.Event.EventProduct"

EVENT_BUNDLE_PATH = "csv/event/event_bundle/data_%d/bundle_pack.csv"

--- @class BundleProduct : EventProduct
BundleProduct = Class(BundleProduct, EventProduct)

function BundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_BUNDLE
end
--[[
function BundleProduct:ClaimAndShowRewardList()
    PopupUtils.ClaimAndShowRewardList(self.rewardResult)
end]]

----------------------------------------------------

--- @class BundleStore : EventStore
BundleStore = Class(BundleStore, EventStore)

--- @return void
function BundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BUNDLE
    --- @type OpCode
    self.opCode = OpCode.EVENT_BUNDLE_PURCHASE
    --- @type string
    self.filePath = EVENT_BUNDLE_PATH
    --- @type EventProduct
    self.pack = BundleProduct
end