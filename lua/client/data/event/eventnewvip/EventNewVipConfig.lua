local COLLECTION_QUEST_PATH = "vip_quest.csv"

--- @class EventNewVipConfig
EventNewVipConfig = Class(EventNewVipConfig)
function EventNewVipConfig:Ctor(path)
	self.path = path
end

--- @return Dictionary
function EventNewVipConfig:GetCollectionQuestConfig()
	if self.collectionQuestDict == nil then
		local path = string.format("%s/%s", self.path, COLLECTION_QUEST_PATH)
		self.collectionQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
	end
	return self.collectionQuestDict
end

return EventNewVipConfig