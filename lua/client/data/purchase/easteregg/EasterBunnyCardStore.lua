local EVENT_EASTER_BUNDLE_CARD_PATH = "csv/event/event_easter/data_%d/bunny_card.csv"

--- @class EasterBunnyCardStore : EventStore
EasterBunnyCardStore = Class(EasterBunnyCardStore, EventStore)

function EasterBunnyCardStore:Ctor()
    EventStore.Ctor(self)
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_EASTER_EGG
    --- @type OpCode
    self.opCode = OpCode.EVENT_EASTER_CARD_PURCHASE
    --- @type string
    self.filePath = EVENT_EASTER_BUNDLE_CARD_PATH
    --- @type EasterBunnyCardProduct
    self.pack = EasterBunnyCardProduct
end

--- @class EasterBunnyCardProduct : EventProduct
EasterBunnyCardProduct = Class(EasterBunnyCardProduct, EventProduct)

function EasterBunnyCardProduct:Ctor()
    EventProduct.Ctor(self)
    self.opCode = OpCode.EVENT_EASTER_CARD_PURCHASE
    self.eventTimeType = EventTimeType.EVENT_EASTER_EGG

    --- @type List
    self.rewardNotInstantList = List()
    --- @type List
    self.rewardInstantList = List()
    --- @type List
    self.rewardList = List()
end

function EasterBunnyCardProduct:ParseCsv(data)
    EventProduct.ParseCsv(self, data)
    if data.duration_in_days ~= nil then
        --- @type number
        self.durationInDays = tonumber(data.duration_in_days)
    end
    if data.id ~= nil then
        ProductConfig.ParseCsv(self, data)
        --- @type number
        self.stock = tonumber(data['stock'])
    end
    if data.res_type ~= nil then
        local reward = RewardInBound.CreateBySingleParam(tonumber(data['res_type']), tonumber(data['res_id']), data['res_number'], data['res_data'])
        self.rewardNotInstantList:Add(reward)
        self.rewardList:Add(reward)
    end
    if data.instant_res_type ~= nil then
        local instantRes = RewardInBound.CreateBySingleParam(tonumber(data['instant_res_type']), tonumber(data['instant_res_id']), data['instant_res_number'], data['instant_res_data'])
        self.rewardInstantList:Add(instantRes)
        self.rewardList:Add(instantRes)
    end
end

function EasterBunnyCardProduct:GetVip()
    --- @param v RewardInBound
    for _, v in ipairs(self.rewardList:GetItems()) do
        if v.type == ResourceType.Money and v.id == MoneyType.VIP_POINT then
            return v:GetNumber()
        end
    end
    return 0
end

function EasterBunnyCardProduct:ClaimAndShowRewardList()
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