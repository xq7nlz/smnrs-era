require "lua.client.core.network.playerData.arena.ArenaChallengeRewardInBound"
require "lua.client.core.network.otherPlayer.OtherPlayerInfoInBound"

--- @class ArenaSingleChallengeInBound
ArenaSingleChallengeInBound = Class(ArenaSingleChallengeInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaSingleChallengeInBound:Ctor(buffer)
    --- @type ArenaChallengeRewardInBound
    self.arenaChallengeReward = ArenaChallengeRewardInBound(buffer)
    --- @type OtherPlayerInfoInBound
    self.defender = OtherPlayerInfoInBound.CreateByBuffer(buffer)
    self.arenaChallengeReward.rewards = NetworkUtils.AddInjectRewardInBoundList(buffer, self.arenaChallengeReward.rewards)
end
