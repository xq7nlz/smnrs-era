require("lua.client.core.network.arenaTeam.ArenaTeamOpponentInfo")
require("lua.client.core.network.arenaTeam.ArenaTeamBotOpponentInfo")

--- @class ArenaTeamOpponentInBound
ArenaTeamOpponentInBound = Class(ArenaTeamOpponentInBound, InBound)

--- @return void
function ArenaTeamOpponentInBound:Ctor()
    ---@type List
    self.listArenaTeamOpponent = List()
    ---@type List
    self.listArenaTeamBot = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaTeamOpponentInBound:Deserialize(buffer)
    self.listArenaTeamOpponent = NetworkUtils.GetListDataInBound(buffer, ArenaTeamOpponentInfo)
    self.listArenaTeamBot = NetworkUtils.GetListDataInBound(buffer, ArenaTeamBotOpponentInfo)
    ---@type number
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end

--- @return ArenaTeamOpponentInBound
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaTeamOpponentInBound.CreateByBuffer(buffer)
    local data = ArenaTeamOpponentInBound()
    data:Deserialize(buffer)
    return data
end