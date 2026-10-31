local BATTLE_PASS_BUNDLE_LEVEL = "csv/event/event_battle_pass/data_%d/bundle/premium_ticket_bundle.csv"

--- @class BattlePassBundlePremiumTicketStore : EventStore
BattlePassBundlePremiumTicketStore = Class(BattlePassBundlePremiumTicketStore, EventStore)

function BattlePassBundlePremiumTicketStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BATTLE_PASS
    --- @type OpCode
    self.opCode = OpCode.EVENT_BATTLE_PASS_PURCHASE
    --- @type string
    self.filePath = BATTLE_PASS_BUNDLE_LEVEL
    --- @type BattlePassBundlePremiumTicketProduct
    self.pack = BattlePassBundlePremiumTicketProduct
end

--- @class BattlePassBundlePremiumTicketProduct : EventProduct
BattlePassBundlePremiumTicketProduct = Class(BattlePassBundlePremiumTicketProduct, EventProduct)

function BattlePassBundlePremiumTicketProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_BATTLE_PASS_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_BATTLE_PASS
end