local EVENT_BUNDLE_PACK_CONFIG_PATH = "csv/event/event_boss_challenge/data_%d/market_pack.csv"
require "lua.client.data.Purchase.EventBossChallenge.BossChallengeGroupPackOfProducts"

--- @class EventBossChallengePremiumPassStore : EventStore
EventBossChallengePremiumPassStore = Class(EventBossChallengePremiumPassStore, EventStore)

function EventBossChallengePremiumPassStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BOSS_CHALLENGE
    --- @type OpCode
    self.opCode = OpCode.EVENT_BOSS_CHALLENGE_CLAIM_PREMIUM_PASS
    --- @type string
    self.filePath = EVENT_BUNDLE_PACK_CONFIG_PATH
    --- @type EventBossChallengePremiumPassProduct
    self.pack = EventBossChallengePremiumPassProduct
end

function EventBossChallengePremiumPassStore:InitPack(ids)
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

--- @class EventBossChallengePremiumPassProduct : EventProduct
EventBossChallengePremiumPassProduct = Class(EventBossChallengePremiumPassProduct, EventProduct)

function EventBossChallengePremiumPassProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_BOSS_CHALLENGE_CLAIM_PREMIUM_PASS
    self.eventTimeType = EventTimeType.EVENT_BOSS_CHALLENGE
end