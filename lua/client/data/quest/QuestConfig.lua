local UI_QUEST_TREE_PATH = "csv/client/quest_tree/quest_tree_%d.json"
local DAILY_QUEST_PATH = "csv/quest/daily_quest.csv"
local ACHIEVEMENT_PATH = "csv/quest/achievement.csv"
local QUEST_TREE_PATH = "csv/quest/quest_tree.csv"
local NEW_DAILY_QUEST_PATH = "csv/quest/new_daily_quest.csv"

--- @class QuestConfig
QuestConfig = Class(QuestConfig)

QuestConfig.GetFromPlayerData = -10

function QuestConfig:Ctor()
    --- @type Dictionary --<number, QuestElementConfig>
    self.dailyQuestDict = nil
    --- @type Dictionary --<number, QuestElementConfig>
    self.newDailyQuestDict = nil
    --- @type Dictionary --<number, QuestElementConfig>
    self.achievementDict = nil
    --- @type Dictionary --<number, QuestElementConfig>
    self.questTreeDict = nil
    --- @type Dictionary
    self.uiQuestTreeDict = nil
end


function QuestConfig:InitNewDailyQuest()
    self.newDailyQuestDict = QuestElementConfig.ReadQuestConfigFromPath(NEW_DAILY_QUEST_PATH)
end


function QuestConfig:InitDailyQuest()
    self.dailyQuestDict = QuestElementConfig.ReadQuestConfigFromPath(DAILY_QUEST_PATH)
end

function QuestConfig:InitAchievement()
    self.achievementDict = QuestElementConfig.ReadQuestConfigFromPath(ACHIEVEMENT_PATH)
end

function QuestConfig:InitQuestTree()
    self.questTreeDict = QuestElementConfig.ReadQuestConfigFromPath(QUEST_TREE_PATH)
end

--- @type Dictionary<number, QuestElementConfig>
function QuestConfig:GetNewDailyQuest()
    if self.newDailyQuestDict == nil then
        self:InitNewDailyQuest()
    end
    return self.newDailyQuestDict
end

--- @type Dictionary<number, QuestElementConfig>
function QuestConfig:GetDailyQuest()
    if self.dailyQuestDict == nil then
        self:InitDailyQuest()
    end
    return self.dailyQuestDict
end


--- @type Dictionary<number, QuestElementConfig>
function QuestConfig:GetAchievement()
    if self.achievementDict == nil then
        self:InitAchievement()
    end
    return self.achievementDict
end

--- @type Dictionary<number, QuestElementConfig>
function QuestConfig:GetQuestTree()
    if self.questTreeDict == nil then
        self:InitQuestTree()
    end
    return self.questTreeDict
end

--- @return QuestType
--- @param questId number
function QuestConfig:GetDailyQuestTypeById(questId)
    --- @type QuestElementConfig
    local questElementConfig = self.dailyQuestDict:Get(questId)
    return questElementConfig:GetQuestType()
end

--- @return QuestType
--- @param questId number
function QuestConfig:GetAchievementTypeById(questId)
    --- @type QuestElementConfig
    local questElementConfig = self.achievementDict:Get(questId)
    return questElementConfig:GetQuestType()
end

--- @return QuestType
--- @param questId number
function QuestConfig:GetQuestTreeTypeById(questId)
    --- @type QuestElementConfig
    local questElementConfig = self.questTreeDict:Get(questId)
    return questElementConfig:GetQuestType()
end

--- @return QuestTree
--- @param clientTreeId number
function QuestConfig:GetUIQuestTree(clientTreeId)
    if self.uiQuestTreeDict == nil then
        require "lua.client.data.Quest.QuestTree.QuestTree"
        self.uiQuestTreeDict = Dictionary()
    end
    local questTree = self.uiQuestTreeDict:Get(clientTreeId)
    if questTree == nil then
        local path = string.format(UI_QUEST_TREE_PATH, clientTreeId)
        local decodeData = CsvReaderUtils.ReadAndParseLocalFile(path, nil, true)
        questTree = QuestTree()
        for k, v in pairs(decodeData) do
            local questTreeNode = QuestTreeNode()
            questTreeNode:InitConfig(v['destNodeLineDict'])
            questTree:AddNodeConfig(tonumber(k), questTreeNode)
        end
        self.uiQuestTreeDict:Add(clientTreeId, questTree)
    end
    return questTree
end

return QuestConfig