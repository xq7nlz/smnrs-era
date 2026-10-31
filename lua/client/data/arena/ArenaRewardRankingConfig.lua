--- @class ArenaRewardRankingConfig
ArenaRewardRankingConfig = Class(ArenaRewardRankingConfig)

--- @return void
function ArenaRewardRankingConfig:Ctor()
    ---@type number
    self.rankType = nil
    ---@type number
    self.eloMin = nil
    ---@type number
    self.eloMax = nil
    ---@type number
    self.topMin = nil
    ---@type number
    self.topMax = nil
    ---@type List
    self.listRewardItem = List()
end

--- @return void
--- @param data string
function ArenaRewardRankingConfig:ParseCsv(data)
    self.rankType = tonumber(data["rank_type"])
    self.eloMin = tonumber(data["elo_min"])
    self.eloMax = tonumber(data["elo_max"])
    self.topMin = tonumber(data["reward_top"])
end

--- @return void
--- @param dataContent string
function ArenaRewardRankingConfig:AddReward(dataContent)
    self.listRewardItem:Add(ItemIconData.CreateInstance(tonumber(dataContent["res_type"]), tonumber(dataContent["res_id"]), tonumber(dataContent["res_number"])))
end

--- @return void
--- @param topNumber number
function ArenaRewardRankingConfig:IsCurrentRanking(topNumber)
    return topNumber >= self.topMin and (self.topMax == nil or topNumber <= self.topMax)
end