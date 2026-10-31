local DUNGEON_CONFIG_PATH = "csv/dungeon/dungeon_config.csv"

--- @class DungeonConfig
DungeonConfig = Class(DungeonConfig)

function DungeonConfig:Ctor()
    self.maxStage = nil

    self:Init()
end

function DungeonConfig:Init()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(DUNGEON_CONFIG_PATH)
    self.maxStage = tonumber(parsedData[#parsedData].stage) - 1
end

return DungeonConfig