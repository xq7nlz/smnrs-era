--- @class LandIdleRewardItemConfig
LandIdleRewardItemConfig = Class(LandIdleRewardItemConfig)

function LandIdleRewardItemConfig:Ctor(parsedData)
    ---@type number
    self.maxIdleNumber = tonumber(parsedData.max_idle_number) -- max so lan roi ra item
    ---@type number
    self.intervalTime = tonumber(parsedData.interval_time) -- thoi gian de roi ra item
    ---@type RewardInBound
    self.rewardInBound = RewardInBound.CreateByParams(parsedData)
end