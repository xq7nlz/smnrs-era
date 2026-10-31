--- @class EventThanksGivingLapDataConfig
EventThanksGivingLapDataConfig = Class(EventThanksGivingLapDataConfig)

function EventThanksGivingLapDataConfig:Ctor(lapRequire, rewardList)
    self.lapRequire = lapRequire
    self.rewardList = rewardList
end
function EventThanksGivingLapDataConfig:GetLapRequire()
    return self.lapRequire
end
function EventThanksGivingLapDataConfig:GetRewardList()
    return self.rewardList
end