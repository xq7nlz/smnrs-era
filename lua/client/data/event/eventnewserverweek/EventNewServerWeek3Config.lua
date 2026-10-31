local QUEST_NEW_SERVER_PATH_3 = "server_open_quest.csv"
--- @class EventNewServerWeek3Config
EventNewServerWeek3Config = Class(EventNewServerWeek3Config)

function EventNewServerWeek3Config:Ctor(path)
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
function EventNewServerWeek3Config:GetTabQuestRewardConfig()
    if self.tabQuestRewardDict == nil then
        local path = string.format("%s/%s", self.path, QUEST_NEW_SERVER_PATH_3)
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
function EventNewServerWeek3Config:GetDictQuestByTabId(tabId)
    return self:GetTabQuestRewardConfig():Get(tonumber(tabId))
end

--- @return Dictionary
function EventNewServerWeek3Config:GetQuestConfigDict()
    if self.questConfigDict == nil then
        local path = string.format("%s/%s", self.path, QUEST_NEW_SERVER_PATH_3)
        self.questConfigDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    end
    return self.questConfigDict
end
