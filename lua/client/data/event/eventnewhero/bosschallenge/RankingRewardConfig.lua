--- @class RankingRewardConfig
RankingRewardConfig = Class(RankingRewardConfig)

function RankingRewardConfig:Ctor()
    --- @type number
    self.min = nil
    --- @type number
    self.max = nil
    --- @type List
    self.listReward = List()
end

--- @return void
function RankingRewardConfig:ParsedData(data)
    self.min = tonumber(data.min)
    self.max = tonumber(data.max)
    self:AddData(data)
end

--- @return void
function RankingRewardConfig:AddData(data)
    if data["res_type"] ~= nil then
        local reward = RewardInBound.CreateByParams(data)
        self.listReward:Add(reward)
    end
end