require "lua.client.data.Purchase.LevelPass.GrowthPackLineConfig"

--- @class EventDailyQuestPassConfig
EventDailyQuestPassConfig = Class(EventDailyQuestPassConfig)

local GROWTH_PACK_BASIC = "csv/event/event_daily_quest_pass/data_%d/daily_quest_pass_free_reward.csv"
local GROWTH_PACK_PREMIUM = "csv/event/event_daily_quest_pass/data_%d/daily_quest_pass_premium_reward.csv"

local BONUS_DAILY_QUEST_REWARD_PATH = "csv/event/event_daily_quest_pass/data_%d/daily_quest_pass_bonus_reward.csv"

function EventDailyQuestPassConfig:Ctor()
    --- @type Dictionary
    self.lineConfig = Dictionary()
    --- @type Dictionary
    self._bonusDailyQuestRewardDict = Dictionary()
end

--- @return GrowthPackLineConfig
--- @param dataId number
function EventDailyQuestPassConfig:GetConfig(dataId)
    if self.lineConfig:IsContainKey(dataId) == false then
        self:_InitLineConfig(dataId)
    end
    return self.lineConfig:Get(dataId)
end

--- @param dataId number
function EventDailyQuestPassConfig:_InitLineConfig(dataId)
    local growthPackLineConfig = GrowthPackLineConfig(dataId, GROWTH_PACK_BASIC, GROWTH_PACK_PREMIUM, "number")
    self.lineConfig:Add(dataId, growthPackLineConfig)
end

--- @return RewardInBound
function EventDailyQuestPassConfig:GetDailyQuestBonusReward(dataId, questId)
    if self._bonusDailyQuestRewardDict:IsContainKey(dataId) == false then
        self:_ReadBonusRewardData(dataId)
    end
    --- @type Dictionary
    local rewardDict = self._bonusDailyQuestRewardDict:Get(dataId)
    return rewardDict:Get(questId)
end

function EventDailyQuestPassConfig:_ReadBonusRewardData(dataId)
    local rewardDict = Dictionary()
    local dataConfig = CsvReaderUtils.ReadAndParseLocalFile(string.format(BONUS_DAILY_QUEST_REWARD_PATH, dataId))
    local listReward = List()
    for i = 1, #dataConfig do
        local questId = dataConfig[i].id
        if questId ~= nil then
            listReward = List()
            listReward:Add(RewardInBound.CreateByParams(dataConfig[i]))
            rewardDict:Add(tonumber(questId), listReward)
        else
            listReward:Add(RewardInBound.CreateByParams(dataConfig[i]))
        end
    end
    self._bonusDailyQuestRewardDict:Add(dataId, rewardDict)
end

return EventDailyQuestPassConfig