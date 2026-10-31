--- @class EventHalloweenLoginDataConfig
EventHalloweenLoginDataConfig = Class(EventHalloweenLoginDataConfig)

function EventHalloweenLoginDataConfig:Ctor(list, rewardInBound)
    ---@type List --<RewardInBound>
    self.rewardList = list
    ---@type RewardInBound
    self.buyDayPrice = rewardInBound
end
function EventHalloweenLoginDataConfig:GetRewardList()
    return self.rewardList
end
function EventHalloweenLoginDataConfig:GetBuyPrice()
    return self.buyDayPrice
end