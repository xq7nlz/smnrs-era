require("lua.client.data.Friend.FriendRankingRewardConfig")

local FRIEND_RANKING_REWARD_PATH = "csv/friend/ranking_reward.csv"

--- @class FriendRankingConfig
FriendRankingConfig = Class(FriendRankingConfig)

--- @return void
function FriendRankingConfig:Ctor()
    --- @type List
    self.list = nil
    self:ReadData()
end

--- @return void
function FriendRankingConfig:ReadData()
    self.list = List()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(FRIEND_RANKING_REWARD_PATH)
    ---@type FriendRankingRewardConfig
    local rewardStage
    for _, v in ipairs(parsedData) do
        local minRanking = tonumber(v['min_ranking'])
        if MathUtils.IsInteger(minRanking) then
            rewardStage = FriendRankingRewardConfig()
            self.list:Add(rewardStage)
            rewardStage:ParseCsv(v)
        else
            rewardStage:AddReward(v)
        end
    end
end

return FriendRankingConfig