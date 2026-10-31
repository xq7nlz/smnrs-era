local EVENT_SALE_OFF_PATH = "csv/event/event_sale_off/data_%d/sale_off_pack.csv"

--- @class SaleOffStore : EventStore
SaleOffStore = Class(SaleOffStore, EventStore)

function SaleOffStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_SALE_OFF
    --- @type SaleOffProductConfig
    self.pack = SaleOffProductConfig
    --- @type OpCode
    self.opCode = OpCode.EVENT_SALE_OFF_PURCHASE
end

function SaleOffStore:InitPack(ids)
    assert(ids)
    self.packConfigDict = Dictionary()
    for _, id in pairs(ids) do

            id = tonumber(id)
        if (id ~= nil) then
            local fullPath = string.format(EVENT_SALE_OFF_PATH, id)
            self.packConfigDict:Add(id, PackOfSaleProducts(self.opCode, self.pack, fullPath))
        end
    end
end

--- @return PackOfSaleProducts
--- @param id number
function SaleOffStore:GetPack(id)
    return EventStore.GetPack(self, id)
end