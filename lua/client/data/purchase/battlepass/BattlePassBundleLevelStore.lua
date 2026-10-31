local BATTLE_PASS_BUNDLE_LEVEL = "csv/event/event_battle_pass/data_%d/bundle/level_bundle.csv"

--- @class BattlePassBundleLevelStore : EventStore
BattlePassBundleLevelStore = Class(BattlePassBundleLevelStore, EventStore)

function BattlePassBundleLevelStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BATTLE_PASS
    --- @type OpCode
    self.opCode = OpCode.EVENT_BATTLE_PASS_LEVEL_PURCHASE
    --- @type string
    self.filePath = BATTLE_PASS_BUNDLE_LEVEL
    --- @type BattlePassBundleLevelProduct
    self.pack = BattlePassBundleLevelProduct

end

--- @class BattlePassBundleLevelProduct : EventProduct
BattlePassBundleLevelProduct = Class(BattlePassBundleLevelProduct, EventProduct)

function BattlePassBundleLevelProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_BATTLE_PASS_LEVEL_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_BATTLE_PASS
end