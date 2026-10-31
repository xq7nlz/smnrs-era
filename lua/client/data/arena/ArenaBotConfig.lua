require "lua.client.data.Arena.ArenaBotData"

local CSV_PATH = "csv/arena/arena_bot/defender_team.csv"

--- @class ArenaBotConfig
ArenaBotConfig = Class(ArenaBotConfig)

function ArenaBotConfig:Ctor()
    ---@type Dictionary  --<id, ArenaBotData>
    self.dict = Dictionary()
    local data = CsvReaderUtils.ReadAndParseLocalFile(CSV_PATH)
    for _, v in ipairs(data) do
        local arenaBotData = ArenaBotData(v)
        self.dict:Add(arenaBotData.botId, arenaBotData)
    end
end

--- @return ArenaBotData
---@param botId number
function ArenaBotConfig:GetArenaBotData(botId)
    return self.dict:Get(botId)
end

return ArenaBotConfig