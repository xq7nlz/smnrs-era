require "lua.client.data.Event.EventXmas.EventXmasLoginDataConfig"
require "lua.client.data.Event.EventLunarNewYear.EventLunarEliteSummonConfig"

local COLLECTION_QUEST_PATH = "collection_quest.csv"

--- @class EventNewHeroCollectionConfig
EventNewHeroCollectionConfig = Class(EventNewHeroCollectionConfig)

function EventNewHeroCollectionConfig:Ctor(path)
    self.path = path
    --- @type Dictionary
    self.collectionQuestDict = nil
end

--- @type Dictionary -- <number, QuestElementConfig>
function EventNewHeroCollectionConfig:GetQuestConfig()
    if self.collectionQuestDict == nil then
        local path = string.format("%s/%s", self.path, COLLECTION_QUEST_PATH)
        self.collectionQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    end
    return self.collectionQuestDict
end