--- @class EventHalloweenLapDataConfig
EventHalloweenLapDataConfig = Class(EventHalloweenLapDataConfig)

function EventHalloweenLapDataConfig:Ctor(lapRequire, rewardList)
    self.lapRequire = lapRequire
    self.rewardList = rewardList
end
function EventHalloweenLapDataConfig:GetLapRequire()
    return self.lapRequire
end
function EventHalloweenLapDataConfig:GetRewardList()
    return self.rewardList
end