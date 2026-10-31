require "lua.client.data.Event.EventXmas.EventXmasLoginDataConfig"

local LOGIN_PATH = "login_reward.csv"
local DAILY_QUEST_PATH = "daily_quest.csv"
local ACCUMULATE_QUEST_PATH = "point_quest.csv"

--- @class EventMergeServerConfig
EventMergeServerConfig = Class(EventMergeServerConfig)

function EventMergeServerConfig:Ctor(path)
    self.path = path
    --- @type Dictionary
    self.dailyQuestDict = nil
    --- @type Dictionary
    self.accumulateQuestDict = nil
end

--- @type Dictionary -- <number, QuestElementConfig>
function EventMergeServerConfig:GetQuestConfig()
    if self.dailyQuestDict == nil then
        self.dailyQuestDict = self:InitQuest(DAILY_QUEST_PATH)
    end
    return self.dailyQuestDict
end

--- @type Dictionary -- <number, QuestElementConfig>
function EventMergeServerConfig:GetAccumulateQuestConfig()
    if self.accumulateQuestDict == nil then
        self.accumulateQuestDict = self:InitQuest(ACCUMULATE_QUEST_PATH)
    end
    return self.accumulateQuestDict
end

--- @return Dictionary
function EventMergeServerConfig:InitQuest(path)
    local path = string.format("%s/%s", self.path, path)
    return QuestElementConfig.ReadQuestConfigFromPath(path)
end

--- @return Dictionary
function EventMergeServerConfig:GetLoginConfig()
    local path = string.format("%s/%s", self.path, LOGIN_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    if self.loginRewardDict == nil then
        local listReward = nil
        -- Dictionary(page, Dictionary(day, List<RewardInBound>)
        self.pageDict = Dictionary()
        self.loginRewardDict = Dictionary()
        local isReclaim = parsedData[1].is_reclaim
        if isReclaim ~= nil then
            self.isReclaim = MathUtils.ToBoolean(isReclaim)
        end
        local page = 1
        local loginDataConfig = nil
        for i = 1, #parsedData do
            local day = parsedData[i].day
            if day == nil then
                loginDataConfig.rewardList:Add(RewardInBound.CreateByParams(parsedData[i]))
            else
                day = tonumber(parsedData[i].day)
                listReward = List()
                listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
                local rewardInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, parsedData[i].money_type, parsedData[i].money_value)
                loginDataConfig = EventXmasLoginDataConfig(listReward, rewardInBound)
                self.loginRewardDict:Add(day, loginDataConfig)
                if day % 7 == 0 then
                    self.pageDict:Add(page, self.loginRewardDict)
                    page = page + 1
                    self.loginRewardDict = Dictionary()
                end
            end
        end
    end
    return self.pageDict
end

--- @return Dictionary
function EventMergeServerConfig:IsNewLogin()
    if self.isReclaim == nil then
        return false
    end
    return self.isReclaim
end

--- @return List
function EventMergeServerConfig:GetListExchangeConfig()
    if self.listExchange == nil then
        local path = string.format("%s/%s", self.path, "exchange_reward.csv")
        require "lua.client.data.Event.ExchangeEventConfig"
        self.listExchange = ExchangeEventConfig.GetListExchangeConfigPath(path)
    end
    return self.listExchange
end