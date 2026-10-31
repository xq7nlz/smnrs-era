require "lua.client.core.network.playerData.defenseMode.challengeResult.DefenseBattleResultInBound"

--- @class RoadBattleResult
RoadBattleResult = Class(RoadBattleResult)

function RoadBattleResult:Ctor()

end

--- @param buffer UnifiedNetwork_ByteBuf
function RoadBattleResult:ReadBuffer(buffer)
    self.listBattleResult = NetworkUtils.GetListDataInBound(buffer, DefenseBattleResultInBound.CreateByBuffer)
end