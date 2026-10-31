local EVENT_BUNDLE_PACK_CONFIG_PATH = "csv/event/event_black_friday_sale/data_%d/customize_bundle.csv"
require "lua.client.data.Purchase.EventBlackFridayNewVersion.EventBlackFridayNewCustomizeProduct"

--- @class EventBlackFridayNewBundleStore : EventStore
EventBlackFridayNewBundleStore = Class(EventBlackFridayNewBundleStore, EventStore)

function EventBlackFridayNewBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BLACK_FRIDAY_SALE
    --- @type OpCode
    self.opCode = OpCode.EVENT_BLACK_FRIDAY_SALE_PURCHASE
    --- @type string
    self.filePath = EVENT_BUNDLE_PACK_CONFIG_PATH
    --- @type EventBlackFridayNewBundleProduct
    self.pack = EventBlackFridayNewBundleProduct
end

function EventBlackFridayNewBundleStore:InitPack(ids)
    self.packConfigDict = Dictionary()
    if ids == nil then
        print ("error init pack nil, opcode ", self.opCode)
        XDebug.Error("InitPack NIL")
        return
    end
    for _, id in pairs(ids) do
        id = tonumber(id)
        if (id ~= nil) then
            local fullPath = string.format(self.filePath, id)
            self.packConfigDict:Add(id, PackOfProducts(self.opCode, EventBlackFridayNewCustomizeProduct, fullPath))
        end

    end
end

--- @class EventBlackFridayNewBundleProduct : EventProduct
EventBlackFridayNewBundleProduct = Class(EventBlackFridayNewBundleProduct, EventProduct)

function EventBlackFridayNewBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_BLACK_FRIDAY_SALE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_BLACK_FRIDAY_SALE
end