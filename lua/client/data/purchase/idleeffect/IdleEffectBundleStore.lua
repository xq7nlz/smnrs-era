local PATH = "csv/event/event_idle_effect_bundle/data_%d/idle_effect_customize_bundle_pack.csv"
--- @class IdleEffectBundleStore : EventStore
IdleEffectBundleStore = Class(IdleEffectBundleStore, EventStore)

function IdleEffectBundleStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_IDLE_EFFECT_BUNDLE
    --- @type OpCode
    self.opCode = OpCode.EVENT_IDLE_EFFECT_CUSTOMIZE_BUNDLE_PURCHASE
    --- @type string
    self.filePath = PATH
    --- @type EventIdleEffectProduct
    self.pack = EventIdleEffectProduct
end

--- @class EventIdleEffectProduct : EventProduct
EventIdleEffectProduct = Class(EventIdleEffectProduct, EventProduct)

function EventIdleEffectProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_IDLE_EFFECT_CUSTOMIZE_BUNDLE_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_IDLE_EFFECT_BUNDLE
    self.numberSelect = 0
    ---@type List
    self.rewardPool = List()
end

--- @return void
function EventIdleEffectProduct:ParseCsv(data)
    if (data.is_hot ~= nil) then
        self.isHot = MathUtils.ToBoolean(data.is_hot)
    end
    EventProduct.ParseCsv(self, data)
    if data.number_selection ~= nil then
        self.numberSelect = tonumber(data.number_selection)
    end
    if data.selection_res_type ~= nil then
        ---@type RewardInBound
        local reward = RewardInBound.CreateBySingleParam(data.selection_res_type, data.selection_res_id,
                data.selection_res_number,
                data.selection_res_data)
        reward.indexId = tonumber(data.selection_id)
        self.rewardPool:Add(reward)
    end
    self.isLimited = self.stock ~= -1
end


function EventIdleEffectProduct:ClaimAndShowRewardList()
    ---@type List <RewardInBound>
    local rewardList = List()
    for i, v in ipairs(self.rewardList:GetItems()) do
        rewardList:Add(v)
    end
    if self.bonusReward ~= nil then
        rewardList:Add(self.bonusReward)
    end
    if self.listSelectReward ~= nil then
        for i, v in ipairs(self.listSelectReward:GetItems()) do
            rewardList:Add(v)
        end
    end
    if (self.numberSelect > 0) then -- http://35.198.248.251/root/idle-summoner/-/issues/4433
        require "lua.client.core.network.event.eventIdleEffect.EventIdleEffectModel"
        ---@type EventIdleEffectModel
        local eventIdleEffectModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_IDLE_EFFECT_BUNDLE)
        if (eventIdleEffectModel ~= nil) then
            --for i = 1, self.numberSelect do
            local selectId = eventIdleEffectModel:GetSelectItemID(self.id)

            if (selectId ~= nil) then
                    rewardList:Add(self.rewardPool:Get(selectId))
            end
            --end
        end

    end
    PopupUtils.ClaimAndShowRewardList(rewardList)
end