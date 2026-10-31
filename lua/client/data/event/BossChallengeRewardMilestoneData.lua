--- @class BossChallengeRewardMilestoneData
BossChallengeRewardMilestoneData = Class(BossChallengeRewardMilestoneData)

function BossChallengeRewardMilestoneData:Ctor()
    self.damage = nil
    ---@type List --<RewardInBound>
    self.listInstantReward = List()
    ---@type List --<RewardInBound>
    self.listReward = List()
    ---@type List --<IconData>
    self.listAllReward = List()
end

--- @return void
function BossChallengeRewardMilestoneData:ParsedData(data)
    self.damage = tonumber(data.milestone_damage)
    self:AddData(data)
end

--- @return void
function BossChallengeRewardMilestoneData:AddData(data)
    if data.instant_res_type ~= nil then
        local reward = RewardInBound.CreateBySingleParam(tonumber(data.instant_res_type), tonumber(data.instant_res_id), tonumber(data.instant_res_number), data.instant_res_data)
        self.listInstantReward:Add(reward)
    end
    if data.res_type ~= nil then
        local reward = RewardInBound.CreateByParams(data)
        self.listReward:Add(reward)

        for i = 1, self.listAllReward:Count() do
            ---@type ItemIconData
            local _data = self.listAllReward:Get(i)
            if _data.type == reward.type and _data.itemId == reward.id and _data.quantity == reward.number then
                return
            end
        end
        self.listAllReward:Add(reward:GetIconData())
    end
end

--- @return void
function BossChallengeRewardMilestoneData:GetIconDataList()
    local data = List()
    for i = 1, self.listReward:Count() do
        ---@type RewardInBound
        local reward = self.listReward:Get(i)
        data:Add(reward:GetIconData())
    end
    return data
end

--- @return void
function BossChallengeRewardMilestoneData:GetAllIconDataList()
    return RewardInBound.GetItemIconDataList(self.listReward)
end