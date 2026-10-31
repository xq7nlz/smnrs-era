--- @class GrowthMilestoneConfig
GrowthMilestoneConfig = Class(GrowthMilestoneConfig)

--- @param number number
function GrowthMilestoneConfig:Ctor(number)
    --- @type number
    self.number = number

    --- @type List -- RewardInBound
    self.listBasicReward = List()
    --- @type List -- RewardInBound
    self.listPremiumReward = List()
end

function GrowthMilestoneConfig:ParseBasicReward(data)
    self.listBasicReward:Add(RewardInBound.CreateByParams(data))
end

function GrowthMilestoneConfig:ParsePremiumReward(data)
    self.listPremiumReward:Add(RewardInBound.CreateByParams(data))
end

function GrowthMilestoneConfig:GetRewardCount()
    return self.listBasicReward:Count() + self.listPremiumReward:Count()
end