local SKIP_BATTLE_CSV = "csv/client/skip_battle.csv"

--- @class SkipBattleConfig
SkipBattleConfig = Class(SkipBattleConfig)

function SkipBattleConfig:Ctor()
    --- @type
    self.turnSkip = nil
    self:ParseCsv()
end

function SkipBattleConfig:ParseCsv()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(SKIP_BATTLE_CSV)
    self.turnSkip = tonumber(parsedData[1].turn)
end

return SkipBattleConfig