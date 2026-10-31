--- @class TavernConfig
TavernConfig = Class(TavernConfig)

--- @return void
function TavernConfig:Ctor()
    --- @type number
    self.numberQuestDaily = nil
    self:ReadCsv()
end

function TavernConfig:ReadCsv()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.TAVERN_CONFIG_PATH)
    self:ParseCsv(parsedData[1])
end

--- @return void
--- @param data string
function TavernConfig:ParseCsv(data)
    self.numberQuestDaily = tonumber(data.number_quest_daily)
end

return TavernConfig