require "lua.client.data.DefenderTeamData"

--- @class ArenaBotData
ArenaBotData = Class(ArenaBotData)

function ArenaBotData:Ctor(parsedData)
    if parsedData ~= nil then
        self:ParseCsv(parsedData)
    end
end

--- @data string
function ArenaBotData:ParseCsv(parsedData)
    --- @type number
    self.botId = tonumber(parsedData.bot_id)
    --- @type number
    self.elo = tonumber(parsedData.elo)
    --- @type DefenderTeamData
    self.defenderTeamData = DefenderTeamData(parsedData)
end