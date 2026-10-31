require "lua.client.core.network.playerData.common.BattleResultInBound"

--- @class LunarChallengeBossInBound
LunarChallengeBossInBound = Class(LunarChallengeBossInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function LunarChallengeBossInBound:Ctor(buffer)
    self.battleResultInfo = BattleResultInBound.CreateByBuffer(buffer, true)
    self.listReward = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer, buffer:GetByte())
end