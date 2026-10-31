require "lua.client.core.network.playerData.arena.ArenaOpponentInfo"
require "lua.client.core.network.playerData.arena.ArenaBotOpponentInfo"

--- @class ArenaOpponentInBound
ArenaOpponentInBound = Class(ArenaOpponentInBound, InBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaOpponentInBound:Ctor(buffer)
    if buffer ~= nil then
        self:Deserialize(buffer)
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaOpponentInBound:Deserialize(buffer)
    --- @type List
    self.listOpponent = NetworkUtils.GetListDataInBound(buffer, ArenaOpponentInfo)
    --- @type List
    self.listBot = NetworkUtils.GetListDataInBound(buffer, ArenaBotOpponentInfo)
    ---@type number
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end

function ArenaOpponentInBound:IsAvailableToRequest()
    return self.lastTimeRequest == nil or zg.timeMgr:GetServerTime() - self.lastTimeRequest > 30
end