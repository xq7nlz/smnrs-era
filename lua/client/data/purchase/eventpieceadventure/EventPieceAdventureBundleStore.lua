local EVENT_BUNDLE_PACK_CONFIG_PATH = "csv/event/event_piece_adventure/data_%d/market_pack.csv"

--- @class EventPieceAdventureBundleStore : EventStore
EventPieceAdventureBundleStore = Class(EventPieceAdventureBundleStore, EventStore)

function EventPieceAdventureBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_PIECE_ADVENTURE
    --- @type OpCode
    self.opCode = OpCode.EVENT_PIECE_ADVENTURE_PURCHASE
    --- @type string
    self.filePath = EVENT_BUNDLE_PACK_CONFIG_PATH
    --- @type EventPieceAdventureBundleProduct
    self.pack = EventPieceAdventureBundleProduct
end

function EventPieceAdventureBundleStore:InitPack(ids)
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
            self.packConfigDict:Add(id, BossChallengeGroupPackOfProducts(self.opCode, self.pack, fullPath))
        end
    end
end

--- @class EventPieceAdventureBundleProduct : EventProduct
EventPieceAdventureBundleProduct = Class(EventPieceAdventureBundleProduct, EventProduct)

function EventPieceAdventureBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_PIECE_ADVENTURE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_PIECE_ADVENTURE
end