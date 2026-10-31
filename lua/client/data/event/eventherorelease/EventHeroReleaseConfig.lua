require "lua.client.data.Event.EventXmas.EventXmasLoginDataConfig"
require "lua.client.data.Event.EventLunarNewYear.EventLunarEliteSummonConfig"
require "lua.client.data.Event.EventNewHero.Summon.EventNewHeroSummonConfig"

local DAILY_QUEST_PATH = "daily_quest/daily_quest_reward.csv"
local SUMMON_QUEST_PATH = "summon_quest.csv"
local COLLECTION_QUEST_PATH = "collection_quest/collection_quest.csv"
local ICON_CONFIG_PATH = "icon_config.csv"

--- @class EventHeroReleaseConfig
EventHeroReleaseConfig = Class(EventHeroReleaseConfig)

function EventHeroReleaseConfig:Ctor(path)
    self.path = path
    --- @type EventNewHeroSummonConfig
    self.eventHeroReleaseSummonConfig = nil
    --- @type Dictionary
    self._bonusDailyQuestRewardDict = Dictionary()
end

--- @type Dictionary -- <number, QuestElementConfig>
function EventHeroReleaseConfig:GetSummonQuestConfig()
    if self.summonQuestDict == nil then
        local path = string.format("%s/%s", self.path, SUMMON_QUEST_PATH)
        self.summonQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    end
    return self.summonQuestDict
end

--- @type Dictionary -- <number, QuestElementConfig>
function EventHeroReleaseConfig:GetCollectionQuestConfig()
    if self.collectionQuestDict == nil then
        local path = string.format("%s/%s", self.path, COLLECTION_QUEST_PATH)
        self.collectionQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    end
    return self.collectionQuestDict
end

--- @return EventNewHeroSummonConfig
function EventHeroReleaseConfig:GetSummonConfig()
    if self.eventHeroReleaseSummonConfig == nil then
        self.eventHeroReleaseSummonConfig = EventNewHeroSummonConfig(self.path)
    end
    return self.eventHeroReleaseSummonConfig
end

--- @return  number, number
function EventHeroReleaseConfig:GetHeroIdAndStar()
    return self:GetSummonConfig():GetHeroIdAndStar()
end

--- @type Dictionary -- <number, QuestElementConfig>
function EventHeroReleaseConfig:GetDailyQuestConfig()
    if self.dailyQuestDict == nil then
        local path = string.format("%s/%s", self.path, DAILY_QUEST_PATH)
        self.dailyQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    end
    return self.dailyQuestDict
end

---@return UnityEngine_Sprite
function EventHeroReleaseConfig:GetEventIcon(dataId)
    local path = string.format("%s/%s", self.path, ICON_CONFIG_PATH)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local isExclusive = MathUtils.ToBoolean(parserData[1].exclusive_icon)
    local imageName
    if isExclusive then
        imageName = tostring(dataId)
    else
        local heroId, _ = self:GetHeroIdAndStar()
        local factionId = ClientConfigUtils.GetFactionIdByHeroId(heroId)
        imageName = "def_" .. factionId
    end
    return ResourceLoadUtils.LoadIconEventHeroRelease(imageName)
end