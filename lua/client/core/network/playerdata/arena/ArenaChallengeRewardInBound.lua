require "lua.client.core.network.playerData.common.BattleResultInBound"

--- @class ArenaChallengeRewardInBound
ArenaChallengeRewardInBound = Class(ArenaChallengeRewardInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaChallengeRewardInBound:Ctor(buffer, defenderElo)
    --- @type BattleResultInBound
    self.battleResult = BattleResultInBound.CreateByBuffer(buffer)
    --- @type number
    self.attackerElo = buffer:GetInt()
    --- @type number
    self.defenderElo = defenderElo
    if self.defenderElo == nil then
        self.defenderElo = buffer:GetInt()
    end
    --- @type number
    self.eloChange = buffer:GetByte()
    --- @type List
    self.rewards = NetworkUtils.GetRewardInBoundList(buffer)
end