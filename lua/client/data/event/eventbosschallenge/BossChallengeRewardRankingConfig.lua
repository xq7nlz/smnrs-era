--- @class BossChallengeRewardRankingConfig
BossChallengeRewardRankingConfig = Class(BossChallengeRewardRankingConfig)

--- @return void
function BossChallengeRewardRankingConfig:Ctor()
    ---@type number
    self.rankType = nil
    ---@type number
    self.bossMin = nil
    ---@type number
    self.bossMax = nil
    ---@type List
    self.listRewardItem = List()
end

--- @return void
--- @param data string
function BossChallengeRewardRankingConfig:ParseCsv(data)
    self.rankType = tonumber(data["rank_type"])
    self.bossMin = tonumber(data["boss_min"])
    self.bossMax = tonumber(data["boss_max"])
end

--- @return void
--- @param dataContent string
function BossChallengeRewardRankingConfig:AddReward(dataContent)
    self.listRewardItem:Add(ItemIconData.CreateInstance(tonumber(dataContent["res_type"]), tonumber(dataContent["res_id"]), tonumber(dataContent["res_number"])))
end

--- @return void
--- @param topNumber number
function BossChallengeRewardRankingConfig:IsCurrentRanking(topNumber)
    --return topNumber >= self.topMin and (self.topMax == nil or topNumber <= self.topMax)
end