require "lua.client.data.ArenaTeam.ArenaTeamBotData"

local CSV_PATH = "csv/arena_team/arena_team_bot/predefine_team.csv"

--- @class ArenaTeamBotConfig
ArenaTeamBotConfig = Class(ArenaTeamBotConfig)

function ArenaTeamBotConfig:Ctor()
    ---@type Dictionary  --<id, ArenaBotData>
    self.dict = Dictionary()
    local data = CsvReaderUtils.ReadAndParseLocalFile(CSV_PATH)
    ---@type ArenaTeamBotData
    local arenaBotData = nil
    for _, v in ipairs(data) do
        if v.bot_id ~= nil then
            arenaBotData = ArenaTeamBotData(v)
            self.dict:Add(arenaBotData.botId, arenaBotData)
        elseif arenaBotData ~= nil then
            arenaBotData:AddDefenderTeamData(v)
        end
    end
end

--- @return ArenaTeamBotData
---@param botId number
function ArenaTeamBotConfig:GetArenaBotData(botId)
    return self.dict:Get(botId)
end

return ArenaTeamBotConfig