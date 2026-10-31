local QUEST_CONFIG = "/summon_quest.csv"
local SUMMON_PRICE = "/summon_price.csv"

--- @class EventNewHeroSkinBundleConfig
EventNewHeroSkinBundleConfig = Class(EventNewHeroSkinBundleConfig)

function EventNewHeroSkinBundleConfig:Ctor(path, dataId)
    --- @type string
    self.path = path
end

---@return List --<QuestElementConfig>
function EventNewHeroSkinBundleConfig:GetListQuest()
    if self.lisQuest == nil then
        local path = self.path .. QUEST_CONFIG
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("Get EventConfig nil %s", path))
            return
        end
        --- @type List
        self.lisQuest = List()
        --- @type QuestElementConfig
        local questConfig
        for i = 1, #parsedData do
            local questId = parsedData[i].quest_id
            if questId ~= nil then
                questConfig = QuestElementConfig.GetInstanceFromCsv(parsedData[i])
                self.lisQuest:Add(questConfig)
            else
                questConfig:AddResData(RewardInBound.CreateByParams(parsedData[i]))
            end
        end
    end
    return self.lisQuest
end