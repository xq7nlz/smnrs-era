local EVENT_BUNDLE_PACK_CONFIG_PATH = "csv/event/event_boss_challenge/data_%d/market_pack.csv"
require "lua.client.data.Purchase.EventBossChallenge.BossChallengeGroupPackOfProducts"

--- @class EventBossChallengeBundleStore : EventStore
EventBossChallengeBundleStore = Class(EventBossChallengeBundleStore, EventStore)

function EventBossChallengeBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BOSS_CHALLENGE
    --- @type OpCode
    self.opCode = OpCode.EVENT_BOSS_CHALLENGE_PURCHASE
    --- @type string
    self.filePath = EVENT_BUNDLE_PACK_CONFIG_PATH
    --- @type EventBossChallengeBundleProduct
    self.pack = EventBossChallengeBundleProduct
end

function EventBossChallengeBundleStore:InitPack(ids)
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

--- @class EventBossChallengeBundleProduct : EventProduct
EventBossChallengeBundleProduct = Class(EventBossChallengeBundleProduct, EventProduct)

function EventBossChallengeBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_BOSS_CHALLENGE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_BOSS_CHALLENGE
end