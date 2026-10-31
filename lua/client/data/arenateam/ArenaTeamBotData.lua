require "lua.client.data.DefenderTeamData"

--- @class ArenaTeamBotData
ArenaTeamBotData = Class(ArenaTeamBotData)

function ArenaTeamBotData:Ctor(parsedData)
    if parsedData ~= nil then
        self:ParseCsv(parsedData)
    end
end

--- @data string
function ArenaTeamBotData:ParseCsv(parsedData)
    --- @type number
    self.botId = tonumber(parsedData.bot_id)
    --- @type number
    self.elo = tonumber(parsedData.elo)
    --- @type List
    self.listDefenderTeamData = List()
    self:AddDefenderTeamData(parsedData)
end

--- @data string
function ArenaTeamBotData:AddDefenderTeamData(parsedData)
    self.listDefenderTeamData:Add(DefenderTeamData(parsedData))
end

--- @data string
function ArenaTeamBotData:GetDefenderTeamData(index)
    return self.listDefenderTeamData:Get(math.min(index, self.listDefenderTeamData:Count()))
end