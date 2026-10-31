--- @class SingleArenaTeamRanking : SingleArenaRanking
SingleArenaTeamRanking = Class(SingleArenaTeamRanking, SingleArenaRanking)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SingleArenaTeamRanking:ReadBuffer(buffer)
    self:ReadBufferWithoutPower(buffer)
end