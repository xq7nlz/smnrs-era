require("lua.client.data.Tavern.TavernQuestDataConfig")

local TAVERN_QUEST_PATH = "csv/tavern/tavern_quest_config.csv"

--- @class TavernQuestConfig
TavernQuestConfig = Class(TavernQuestConfig)

function TavernQuestConfig:Ctor()
    --- @type Dictionary  --<star, TavernQuestDataConfig>
    self.dict = nil
    self:ReadData()
end

function TavernQuestConfig:ReadData()
    self.dict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(TAVERN_QUEST_PATH)
    for i = 1, #parsedData do
        local data = TavernQuestDataConfig()
        data:ParseCsv(parsedData[i])
        self.dict:Add(data.star, data)
    end
    return self.dict
end

---@return TavernQuestDataConfig
---@param star number
function TavernQuestConfig:GetQuestDataByStar(star)
    return self.dict:Get(star)
end

return TavernQuestConfig