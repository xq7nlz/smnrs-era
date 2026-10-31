--- @class EventStore : PurchaseStore
EventStore = Class(EventStore, PurchaseStore)

--- @return void
function EventStore:Ctor()
    PurchaseStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = nil
    --- @type OpCode
    self.opCode = nil
    --- @type string
    self.filePath = nil
    --- @type EventProduct
    self.pack = nil
end

function EventStore:InitPack(ids)
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

            self.packConfigDict:Add(id, PackOfProducts(self.opCode, self.pack, fullPath))
        end

    end
end

function EventStore:SetKey()
    --- @param purchasePack PackOfProducts
    for dataId, purchasePack in pairs(self.packConfigDict:GetItems()) do
        --- @param pack ProductConfig
        for _, pack in pairs(purchasePack:GetAllPackBase():GetItems()) do
            pack.dataId = dataId
            pack:SetKey()
        end
    end
end

--- @return PackOfProducts
function EventStore:GetCurrentPack()
    local packId = zg.playerData:GetEvents():GetEvent(self.eventTimeType):GetTime().dataId
    return self:GetPack(packId)
end