require "lua.client.data.DefenseMode.defenseBattle.DefenseTowerData"

--- @class DefenseStageTowerConfig
DefenseStageTowerConfig = Class(DefenseStageTowerConfig)

local pathTowerFormat = "csv/defense_mode/land_%d/stage_%d/tower_config.csv"

function DefenseStageTowerConfig:Ctor(land, stage)
    --- @type Dictionary
    self._defenseTowerDict = Dictionary()
    self:_ReadDataConfig(land, stage)
end

function DefenseStageTowerConfig:_ReadDataConfig(land, stage)
    local parsedCsv = CsvReaderUtils.ReadAndParseLocalFile(string.format(pathTowerFormat, land, stage))
    for i = 1, #parsedCsv do
        local id = tonumber(parsedCsv[i].id)
        local defenseTowerData = DefenseTowerData(parsedCsv[i])
        self._defenseTowerDict:Add(id, defenseTowerData)
    end
end

--- @return number
function DefenseStageTowerConfig:GetAvailableRoad()
    return self._defenseTowerDict:Count()
end

--- @return DefenseTowerData
function DefenseStageTowerConfig:GetDefenseTowerData(road)
    return self._defenseTowerDict:Get(road)
end