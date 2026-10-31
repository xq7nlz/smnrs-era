require "lua.client.data.DefenseMode.Land.LandIdleRewardItemConfig"

--- @class LandIdleRewardConfig
LandIdleRewardConfig = Class(LandIdleRewardConfig)

function LandIdleRewardConfig:Ctor(parsedData)
    ---@type number
    self.stage = tonumber(parsedData.stage)
    ---@type List  --<LandIdleRewardItemConfig>
    self.listReward = List()
end

function LandIdleRewardConfig:AddReward(parsedData)
    self.listReward:Add(LandIdleRewardItemConfig(parsedData))
end