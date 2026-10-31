--- @class LandStageConfig
LandStageConfig = Class(LandStageConfig)

function LandStageConfig:Ctor(parsedData)
    ---@type number
    self.stage = tonumber(parsedData.stage)
    ---@type List --<RewardInBound>
    self.listReward = List()
end

function LandStageConfig:AddReward(parsedData)
    self.listReward:Add(RewardInBound.CreateByParams(parsedData))
end

function LandStageConfig:GetListIconData()
    local list = List()
    for i = 1, self.listReward:Count() do
        ---@type RewardInBound
        local data = self.listReward:Get(i)
        list:Add(data:GetIconData())
    end
    return list
end