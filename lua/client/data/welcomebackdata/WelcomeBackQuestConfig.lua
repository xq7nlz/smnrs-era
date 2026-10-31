require "lua.client.data.Event.EventXmas.EventXmasLoginDataConfig"

local QUEST_PATH = "csv/comeback/data_%s/daily_quest_reward.csv"

--- @class WelcomeBackQuestConfig
WelcomeBackQuestConfig = Class(WelcomeBackQuestConfig)

function WelcomeBackQuestConfig:Ctor(dataId)
    self.dataId = dataId
    --- @type Dictionary
    self.dailyQuestDict = QuestElementConfig.ReadQuestConfigFromPath(string.format(QUEST_PATH, dataId))
end