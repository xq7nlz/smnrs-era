local PATH = "csv/event/event_idle_effect_bundle/data_%d/idle_effect_random_bundle_pack.csv"
--- @class RandomIdleEffectBundleStore: EventStore
RandomIdleEffectBundleStore = Class(RandomIdleEffectBundleStore, EventStore)

function RandomIdleEffectBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_IDLE_EFFECT_BUNDLE
    --- @type OpCode
    self.opCode = OpCode.EVENT_IDLE_EFFECT_RANDOM_BUNDLE_PURCHASE
    --- @type string
    self.filePath = PATH
    --- @type RandomEventIdleEffectProduct
    self.pack = RandomEventIdleEffectProduct
end

--- @class RandomEventIdleEffectProduct : EventProduct
RandomEventIdleEffectProduct = Class(RandomEventIdleEffectProduct, EventProduct)

function RandomEventIdleEffectProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_IDLE_EFFECT_RANDOM_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_IDLE_EFFECT_BUNDLE
    self.numberSelect = 0
    ---@type List
    self.rewardPool = List()
end


--- @return void
function RandomEventIdleEffectProduct:ParseCsv(data)
    if (data.is_hot ~= nil) then
        self.isHot = MathUtils.ToBoolean(data.is_hot)
    end
    EventProduct.ParseCsv(self, data)
    self.isLimited = self.stock ~= -1
end


function RandomEventIdleEffectProduct:ClaimAndShowRewardList()
    PopupUtils.ClaimAndShowRewardList(self.rewardResult)
end