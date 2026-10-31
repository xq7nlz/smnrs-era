require "lua.client.core.network.playerData.common.BattleResultInBound"
require "lua.client.core.network.otherPlayer.OtherPlayerInfoInBound"

--- @class ArenaTeamBattleResultInfo
ArenaTeamBattleResultInfo = Class(ArenaTeamBattleResultInfo)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaTeamBattleResultInfo:Ctor(buffer)
    --- @type BattleResultInBound
    self.battleResultInfo = BattleResultInBound.CreateByBuffer(buffer)
    --- @type number
    self.teamIndex = buffer:GetByte()
    --- @type OtherPlayerInfoInBound
    self.defender = OtherPlayerInfoInBound.CreateByBuffer(buffer)
end