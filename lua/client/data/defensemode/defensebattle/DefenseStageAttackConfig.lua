require "lua.client.data.DefenseMode.defenseBattle.DefenseWaveData"

--- @class DefenseStageAttackConfig
DefenseStageAttackConfig = Class(DefenseStageAttackConfig)

local pathAttackerFormat = "csv/defense_mode/land_%s/stage_%s/attacker_config.csv"

function DefenseStageAttackConfig:Ctor(land, stage)
    --- @type Dictionary
    self._defenseWaveDict = Dictionary()
    self:_ReadDataConfig(land, stage)
end

function DefenseStageAttackConfig:_ReadDataConfig(land, stage)
    local path = string.format(pathAttackerFormat, land, stage)
    local parsedCsv = CsvReaderUtils.ReadAndParseLocalFile(string.format(pathAttackerFormat, land, stage))
    for i = 1, #parsedCsv do
        local id = tonumber(parsedCsv[i].id)
        local road = id / 1000
        local listData = self._defenseWaveDict:Get(road)
        if listData == nil then
            listData = List()
            self._defenseWaveDict:Add(road, listData)
        end
        local defenseWaveData = DefenseWaveData(parsedCsv[i])
        listData:Add(defenseWaveData)
    end
end

--- @return List -- DefenseWaveData
function DefenseStageAttackConfig:GetListWaveDataByRoad(road)
    return self._defenseWaveDict:Get(road)
end