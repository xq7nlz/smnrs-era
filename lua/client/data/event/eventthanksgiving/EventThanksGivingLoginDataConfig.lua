--- @class EventThanksGivingLoginDataConfig
EventThanksGivingLoginDataConfig = Class(EventThanksGivingLoginDataConfig)

function EventThanksGivingLoginDataConfig:Ctor(list, rewardInBound)
    ---@type List --<RewardInBound>
    self.rewardList = list
    ---@type RewardInBound
    self.buyDayPrice = rewardInBound
end
function EventThanksGivingLoginDataConfig:GetRewardList()
    return self.rewardList
end
function EventThanksGivingLoginDataConfig:GetBuyPrice()
    return self.buyDayPrice
end