require "lua.client.data.Event.EventHalloween.EventHalloweenLoginDataConfig"

local QUEST_NEW_SERVER_PATH = "server_open_quest.csv"
local LOGIN_REWARD = "login_reward.csv"
--- @class EventNewServerWeekConfig
EventNewServerWeekConfig = Class(EventNewServerWeekConfig)

function EventNewServerWeekConfig:Ctor(path)
    ---@type List -- LevelOnEXP
    self.levelExpList = nil
    ---@type Dictionary
    self.tabQuestRewardDict = nil
    ---@type Dictionary
    self.questConfigDict = nil

    --- @type Dictionary -- <number, RewardInBound>
    self.exchangeRewardDict = nil

    ---@type List -- LevelOnEXP
    self.lineRewardList = nil

    --- @type Dictionary -- <number, LineRewardConfig>
    self.lineRewardDict = nil
    self.path = path
    ---@type number
    self.levelMax = nil
end

--- @type Dictionary -- <number, Dictionary < number,QuestElementConfig>>
function EventNewServerWeekConfig:GetTabQuestRewardConfig()
    if self.tabQuestRewardDict == nil then
        local path = string.format("%s/%s", self.path, QUEST_NEW_SERVER_PATH)
        self.tabQuestRewardDict = Dictionary()
        local parseData = CsvReaderUtils.ReadAndParseLocalFile(path)

        local tabNumber = nil
        local lastQuestId = nil;
        for i = 1, #parseData do
            local lineData = parseData[i]
            local questID = lineData.quest_id
            if questID ~= nil then
                ---@type QuestElementConfig
                local questElementConfig = QuestElementConfig.GetInstanceFromCsv(lineData)
                if (lineData.tab_id ~= nil) then
                    tabNumber = tonumber(lineData.tab_id)
                end
                if (self.tabQuestRewardDict:IsContainKey(tabNumber)) then
                    ---@type Dictionary
                    local tabQuestDict = self.tabQuestRewardDict:Get(tabNumber)
                    tabQuestDict:Add(questID, questElementConfig)
                else
                    local tabQuestDict = Dictionary()
                    tabQuestDict:Add(questID, questElementConfig)
                    self.tabQuestRewardDict:Add(tabNumber, tabQuestDict)
                    lastQuestId = questID
                end
            else
                self.tabQuestRewardDict:Get(tabNumber):Get(lastQuestId):AddResData(RewardInBound.CreateByParams(lineData))
            end
        end
    end
    return self.tabQuestRewardDict
end

---@return Dictionary < number,QuestElementConfig>>
function EventNewServerWeekConfig:GetDictQuestByTabId(tabId)
    return self:GetTabQuestRewardConfig():Get(tonumber(tabId))
end

--- @return Dictionary
function EventNewServerWeekConfig:GetQuestConfigDict()
    if self.questConfigDict == nil then
        local path = string.format("%s/%s", self.path, QUEST_NEW_SERVER_PATH)
        self.questConfigDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    end
    return self.questConfigDict
end


--- @return Dictionary
function EventNewServerWeekConfig:GetLoginConfig()
    local path = string.format("%s/%s", self.path,LOGIN_REWARD )
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    if self.loginRewardDict == nil then
        local listReward = nil
        self.loginRewardDict = Dictionary()
        --- @type EventHalloweenLoginDataConfig
        local loginDataConfig  = nil
        for i = 1, #parsedData do
            local day = parsedData[i].day
            if day == nil then
                listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
            else
                day = tonumber(parsedData[i].day)
                listReward = List()
                listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
                local rewardInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, parsedData[i].money_type, parsedData[i].money_value)
                loginDataConfig = EventHalloweenLoginDataConfig(listReward, rewardInBound)
                self.loginRewardDict:Add(day, loginDataConfig)
            end
        end
    end
    return self.loginRewardDict
end