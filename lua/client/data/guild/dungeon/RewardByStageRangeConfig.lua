--- @class RewardByStageRangeConfig
RewardByStageRangeConfig = Class(RewardByStageRangeConfig)

--- @param minStagePassed number
--- @param maxStagePassed number
function RewardByStageRangeConfig:Ctor(minStagePassed, maxStagePassed)
    --- @type number
    self.minStagePassed = minStagePassed
    --- @type number
    self.maxStagePassed = maxStagePassed
    --- @type List
    self.listReward = List()
end

function RewardByStageRangeConfig:AddRewardByData(parsedData)
    self.listReward:Add(RewardInBound.CreateByParams(parsedData))
end