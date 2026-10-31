--- @class FriendRankingRewardConfig
FriendRankingRewardConfig = Class(FriendRankingRewardConfig)

--- @return void
function FriendRankingRewardConfig:Ctor()
    ---@type number
    self.minRanking = nil
    ----@type number
    self.maxRanking = nil
    ----@type List
    self.listRewardItem = List()
end

--- @return void
function FriendRankingRewardConfig:ParseCsv(dataContent)
    self.minRanking = tonumber(dataContent["min_ranking"])
    self.maxRanking = tonumber(dataContent["max_ranking"])
    self:AddReward(dataContent)
end

--- @return void
function FriendRankingRewardConfig:AddReward(dataContent)
    self.listRewardItem:Add(ItemIconData.CreateInstance(tonumber(dataContent["res_type"]), tonumber(dataContent["res_id"]), tonumber(dataContent["res_number"])))
end

return FriendRankingRewardConfig