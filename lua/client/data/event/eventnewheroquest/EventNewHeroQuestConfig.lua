require "lua.client.data.Event.EventLunarNewYear.EventLunarEliteSummonConfig"

local DAILY_QUEST_PATH = "daily_quest.csv"

--- @class EventNewHeroQuestConfig
EventNewHeroQuestConfig = Class(EventNewHeroQuestConfig)

function EventNewHeroQuestConfig:Ctor(path)
    self.path = path
    --- @type Dictionary
    self.dailyQuestDict = nil
end

--- @type Dictionary -- <number, QuestElementConfig>
function EventNewHeroQuestConfig:GetQuestConfig()
    if self.dailyQuestDict == nil then
        local path = string.format("%s/%s", self.path, DAILY_QUEST_PATH)
        self.dailyQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    end
    return self.dailyQuestDict
end