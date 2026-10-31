local ARENA_ELO_RESET_CONFIG = "csv/arena/arena_elo_reset_config.csv"

--- @class ArenaResetConfig
ArenaResetConfig = Class(ArenaResetConfig)

--- @return void
function ArenaResetConfig:Ctor()
    ---@type Dictionary
    self.dictEloReset = Dictionary()

    self:InitData()
end

--- @return void
function ArenaResetConfig:InitData()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(ARENA_ELO_RESET_CONFIG)
    for _, v in ipairs(parsedData) do
        self.dictEloReset:Add(tonumber(v.rank_type), tonumber(v.elo))
    end
end

--- @return number
function ArenaResetConfig:GetEloReset(rankType)
    local elo = self.dictEloReset:Get(rankType)
    if elo == nil then
        elo = 0
        XDebug.Error("can't get elo: %s" .. tostring(rankType))
    end
    return elo
end

return ArenaResetConfig