local EVENT_BLACK_FRIDAY_PATH = "csv/event/event_black_friday/data_%d/event_card.csv"

local CALCULATOR_TYPE = {
    ADD = 1,
    MULTIPLY = 2,
}
local FACTOR_TYPE = {
    VIP_LEVEL = 1,
    LEVEL_SUMMON = 2,
}

--- @class BlackFridayCardStore : EventStore
BlackFridayCardStore = Class(BlackFridayCardStore, EventStore)

function BlackFridayCardStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BLACK_FRIDAY
    --- @type OpCode
    self.opCode = OpCode.EVENT_BLACK_FRIDAY_CARD_PURCHASE
    --- @type string
    self.filePath = EVENT_BLACK_FRIDAY_PATH
    --- @type EventBlackFridayCardProduct
    self.pack = EventBlackFridayCardProduct
end

--- @class EventBlackFridayCardProduct : EventProduct
EventBlackFridayCardProduct = Class(EventBlackFridayCardProduct, EventProduct)

function EventBlackFridayCardProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_BLACK_FRIDAY_CARD_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_BLACK_FRIDAY
    self.rewardNotInstantList = List()
    self.rewardCalculationList = List()
    self.rewardFactorCalculationList = List()
    self.rewardInstantList = List()
    self.rewardStaticList = List()
end

function EventBlackFridayCardProduct:ParseCsv(data)
    if data.id ~= nil then
        ProductConfig.ParseCsv(self, data)
        --- @type number
        self.stock = tonumber(data['stock'])
        local instantRes = RewardInBound.CreateBySingleParam(tonumber(data['instant_res_type']), tonumber(data['instant_res_id']), tonumber(data['instant_res_number']), tonumber(data['instant_res_data']))
        self.rewardInstantList:Add(instantRes)
    end
    local reward = RewardInBound.CreateByParams(data)
    self.rewardNotInstantList:Add(reward)
    local calculationType = tonumber(data['calculation_type'])
    self.rewardCalculationList:Add(calculationType)
    local calculationFactorType = tonumber(data['calculation_factor_type'])
    self.rewardFactorCalculationList:Add(calculationFactorType)
end

function EventBlackFridayCardProduct:ClaimAndShowRewardList()
    ---@type List -- <RewardInBound>
    local rewardList = self:GetRewardList()
    if self.bonusReward ~= nil then
        rewardList:Add(self.bonusReward)
    end
    for i = rewardList:Count(), 1, -1 do
        --- @type RewardInBound
        local rewardInBound = rewardList:Get(i)
        if rewardInBound.id ~= ResourceType.Money
                or rewardInBound.type ~= MoneyType.VIP_POINT then
            rewardList:RemoveByIndex(i)
        end
    end
    PopupUtils.ClaimAndShowRewardList(rewardList)
end

function EventBlackFridayCardProduct:GetVipAndRewardListWithCondition(isBought)
    self.rewardList:Clear()
    self.rewardStaticList:Clear()
    local vipReward
    for _, v in ipairs(self.rewardInstantList:GetItems()) do
        if v.type == ResourceType.Money and v.id == MoneyType.VIP_POINT then
            vipReward = v.number
            break
        end
    end

    for i = 1, self.rewardNotInstantList:Count() do
        local reward = RewardInBound.CreateBySingleParam(self.rewardNotInstantList:Get(i).type, self.rewardNotInstantList:Get(i).id, self.rewardNotInstantList:Get(i).number)
        local allVip = isBought and InventoryUtils.GetMoney(MoneyType.VIP_POINT) or vipReward + InventoryUtils.GetMoney(MoneyType.VIP_POINT)
        local factor = 0
        if self.rewardFactorCalculationList:Get(i) == FACTOR_TYPE.VIP_LEVEL then
            factor = ResourceMgr.GetVipConfig():GetVipLevel(allVip)
        elseif self.rewardFactorCalculationList:Get(i) == FACTOR_TYPE.LEVEL_SUMMON then
            factor = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level
        end
        if self.rewardCalculationList:Get(i) == CALCULATOR_TYPE.ADD then
            reward.number = reward.number + factor
        elseif self.rewardCalculationList:Get(i) == CALCULATOR_TYPE.MULTIPLY then
            reward.number = reward.number * factor
        end
        if isBought then
            self.rewardStaticList:Add(reward)
        else
            self.rewardStaticList:Add(self.rewardNotInstantList:Get(i))
        end
        self.rewardList:Add(reward)
    end

    for _, v in ipairs(self.rewardInstantList:GetItems()) do
        self.rewardList:Add(v)
    end

    local list = List()
    --- @param v RewardInBound
    for _, v in ipairs(self.rewardList:GetItems()) do
        if v.type == ResourceType.Money and v.id == MoneyType.VIP_POINT then
            vipReward = v.number
        else
            list:Add(v)
        end
    end
    return vipReward, list, self.rewardStaticList, self.rewardCalculationList, self.rewardFactorCalculationList
end