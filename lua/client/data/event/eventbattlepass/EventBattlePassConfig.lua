require "lua.client.data.Event.ExchangeEventConfig"

local LEVEL_EXP_PATH = "level_config.csv"
local WEEKLY_QUEST_PATH = "weekly_quest.csv"
local EXCHANGE_REWARD_PATH = "exchange_exp.csv"
local LEVEL_REWARD_PATH = "level_reward.csv"

--- @class LineRewardConfig
LineRewardConfig = Class(LineRewardConfig)

function LineRewardConfig:Ctor()
    ---@type RewardInBound
    self.reward = nil
    ---@type boolean
    self.isFree = false
    ---@type number
    self.level = nil
end

---@return boolean
function LineRewardConfig:CanGetReward(userCurrentLevel, isPurchasedPremium)
    return userCurrentLevel >= self.level and (isPurchasedPremium or self.isFree)
end

--- @class LevelOnEXP
LevelOnEXP = Class(LevelOnEXP)
function LevelOnEXP:Ctor()
    ---@type number
    self.level = nil
    ---@type number
    self.exp = nil  -- exp min
    ---@type number
    self.gap = nil
    ---@type number
    self.totalExp = nil -- exp max
    ---@type number
    self.levelIndex = nil -- index in list
end

--- @class EventBattlePassConfig
EventBattlePassConfig = Class(EventBattlePassConfig)

function EventBattlePassConfig:Ctor(path)
    ---@type List -- LevelOnEXP
    self.levelExpList = nil
    ---@type Dictionary
    self.weeklyQuestRewardDict = nil
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

---@return  RewardInBound
function EventBattlePassConfig:GetFinalReward()
    ---@type List
    local listFinalReward = self:GetLineRewardConfig()
    return listFinalReward:Get(listFinalReward:Count()).reward
end

---@return  RewardInBound
function EventBattlePassConfig:GetFirstReward()
    ---@type List
    local listFinalReward = self:GetLineRewardConfig()
    return listFinalReward:Get(1).reward
end




function EventBattlePassConfig:GetLevelMax()
    if (self.levelMax == nil) then
        ---@type List
        local lineRewardList = self:GetLineRewardConfig()
        local lastLevelIndex = lineRewardList:Count()
        self.levelMax = tonumber(lineRewardList:Get(lastLevelIndex).level)
    end

    return self.levelMax
end

--- @return List
function EventBattlePassConfig:GetLineRewardConfig()
    if self.lineRewardList == nil then
        self.lineRewardList = List()
        local path = string.format("%s/%s", self.path, LEVEL_REWARD_PATH)
        local parseData = CsvReaderUtils.ReadAndParseLocalFile(path)
        for i = 1, #parseData do
            local lineData = parseData[i]
            local level = tonumber(lineData.level)
            local reward = RewardInBound.CreateByParams(lineData)
            ---@type LineRewardConfig
            local lineRewardConfig = LineRewardConfig()
            lineRewardConfig.reward = reward
            lineRewardConfig.isFree = lineData.is_free
            lineRewardConfig.level = level
            if self.lineRewardDict == nil then
                self.lineRewardDict = Dictionary()
            end
            if (not self.lineRewardDict:IsContainValue(level)) then
                self.lineRewardDict:Add(level, lineRewardConfig)
            end
            self.lineRewardList:Add(lineRewardConfig)
        end
    end
    return self.lineRewardList
end

---@return Dictionary < number,QuestElementConfig>>
function EventBattlePassConfig:GetDictQuestByWeek(weekid)
    return self:GetWeeklyQuestRewardConfig():Get(tonumber(weekid))
end

---@return number
function EventBattlePassConfig:GetExpOnLevelMax()
    local levelExpList = self:GetLevelExpRewardListConfig()
    ---@type LevelOnEXP
    local maxLevelOnEXP = levelExpList:Get(levelExpList:Count())
    return maxLevelOnEXP.exp
end


---@return LevelOnEXP
function EventBattlePassConfig:GetLevelByExp(exp)
    local _exp = tonumber(exp)

    ---@type List
    local levelExpList = self:GetLevelExpRewardListConfig()
    local count = levelExpList:Count()
    --XDebug.Log("count " .. tostring(count))
    for i = levelExpList:Count(), 1, -1 do
        ---@type LevelOnEXP
        local levelOnEXP = levelExpList:Get(i)
        local levelexp = levelOnEXP.exp
        if (_exp >= levelexp) then
            --XDebug.Log("levelexp " .. tostring(levelOnEXP.level))
            return levelOnEXP
        else
            --  XDebug.Log("levelexp not enough " .. tostring(levelOnEXP.level))
        end
    end

end

--- @type List -- <LevelOnEXP>
function EventBattlePassConfig:GetLevelExpRewardListConfig()
    if self.levelExpList == nil then
        self.levelExpList = List()
        local path = string.format("%s/%s", self.path, LEVEL_EXP_PATH)
        local curExp = 0
        local curLevel = 0
        local exp_gap = 0
        local parseData = CsvReaderUtils.ReadAndParseLocalFile(path)
        local count = 1
        for i = 1, #parseData do
            count = i + 1
            local lineData = parseData[i]
            exp_gap = lineData.exp_required
            ---@type LevelOnEXP
            self:AddLevelOnExp(curLevel, curExp, exp_gap, i)
            curExp = curExp + exp_gap
            curLevel = tonumber(lineData.level) --next level
        end
        self:AddLevelOnExp(curLevel, curExp, exp_gap, count)
    end
    return self.levelExpList
end

function EventBattlePassConfig:AddLevelOnExp(curLevel, curExp, exp_required, levelIndex)

    local levelOnEXP = LevelOnEXP()
    levelOnEXP.level = tonumber(curLevel)  -- level on csv
    levelOnEXP.exp = tonumber(curExp)
    levelOnEXP.gap = tonumber(exp_required) -- for next level
    levelOnEXP.totalExp = curExp + levelOnEXP.gap
    levelOnEXP.levelIndex = levelIndex -- index in list
    self.levelExpList:Add(levelOnEXP)
    --XDebug.Log("add level " .. tostring(levelOnEXP.level) .. "exp " .. tostring(levelOnEXP.exp))
end

--[[--- @type Dictionary -- <number, LevelOnEXP>
function EventBattlePassConfig:GetLevelExpRewardConfig()
    if self.levelExpDict == nil then
        self.levelExpDict = Dictionary()
        local levelExpList = self:GetLevelExpRewardListConfig()
        ---@param v LevelOnEXP
        for k, v in pairs(levelExpList:GetItems()) do
            self.levelExpDict:Add(v.level, v)
        end
    end
    return self.levelExpDict
end]]

--- @type Dictionary -- <number, Dictionary < number,QuestElementConfig>>
function EventBattlePassConfig:GetWeeklyQuestRewardConfig()
    if self.weeklyQuestRewardDict == nil then
        local path = string.format("%s/%s", self.path, WEEKLY_QUEST_PATH)
        self.weeklyQuestRewardDict = Dictionary()
        local parseData = CsvReaderUtils.ReadAndParseLocalFile(path)
        local weekNumber = nil
        for i = 1, #parseData do
            local lineData = parseData[i]
            local questID = lineData.quest_id
            ---@type QuestElementConfig
            local questElementConfig = QuestElementConfig.GetInstanceFromCsv(lineData)
            if (lineData.week ~= nil) then
                weekNumber = tonumber(parseData[i].week)
            end
            if (self.weeklyQuestRewardDict:IsContainKey(weekNumber)) then
                ---@type Dictionary
                local weeklyQuestDict = self.weeklyQuestRewardDict:Get(weekNumber)
                weeklyQuestDict:Add(questID, questElementConfig)
            else
                local weeklyQuestDict = Dictionary()
                weeklyQuestDict:Add(questID, questElementConfig)
                self.weeklyQuestRewardDict:Add(weekNumber, weeklyQuestDict)
            end
        end
    end
    return self.weeklyQuestRewardDict
end

--- @return Dictionary
function EventBattlePassConfig:GetQuestConfigDict()
    if self.questConfigDict == nil then
        local path = string.format("%s/%s", self.path, WEEKLY_QUEST_PATH)
        self.questConfigDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    end
    return self.questConfigDict
end

--- @return ExchangeEventConfig
function EventBattlePassConfig:GetExchangeExpConfig()
    if self.exchangeExpConfig == nil then
        local path = string.format("%s/%s", self.path, EXCHANGE_REWARD_PATH)
        local listExchangeConfig = ExchangeEventConfig.GetListExchangeConfigPath(path)
        self.exchangeExpConfig = listExchangeConfig:Get(1)
    end
    return self.exchangeExpConfig
end