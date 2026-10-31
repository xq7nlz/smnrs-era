local UI_DAILY_REWARD = "csv/daily/reward/daily_rewards_0.csv"

--- @class DailyRewardTestConfig
DailyRewardTestConfig = Class(DailyRewardTestConfig)

function DailyRewardTestConfig:Ctor()
    --- @type List --<RewardInBound>
    self.listData = nil
end

function DailyRewardTestConfig:InitDailyReward()
    self.listData = List()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(UI_DAILY_REWARD)
    for i = 1, #parsedData do
        self.listData:Add(RewardInBound.CreateByParams(parsedData[i]))
        XDebug.Log(RewardInBound.CreateByParams(parsedData[i]).id)
    end
end

--- @return DailyRewardTestConfig
--- @type List --<RewardInBound>
function DailyRewardTestConfig:GetListData()
    if self.listData == nil then
        self:InitDailyReward()
    end
    return self.listData
end

return DailyRewardTestConfig