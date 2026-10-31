local CHALLENGE_BUNDLE_PACK_CONFIG_PATH = "csv/event/event_skin_challenge/data_%d/bundle_pack.csv"

--- @class SkinChallengeBundleStore : EventStore
SkinChallengeBundleStore = Class(SkinChallengeBundleStore, EventStore)

function SkinChallengeBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_SKIN_CHALLENGE
    --- @type OpCode
    self.opCode = OpCode.EVENT_SKIN_CHALLENGE_BUNDLE_PURCHASE
    --- @type string
    self.filePath = CHALLENGE_BUNDLE_PACK_CONFIG_PATH
    --- @type SkinChallengeBundleProduct
    self.pack = SkinChallengeBundleProduct
end

--- @class SkinChallengeBundleProduct : EventProduct
SkinChallengeBundleProduct = Class(SkinChallengeBundleProduct, EventProduct)

function SkinChallengeBundleProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_SKIN_CHALLENGE_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_SKIN_CHALLENGE
end