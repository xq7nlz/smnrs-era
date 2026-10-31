--- @class EventChallengeRewardResultInBound
EventChallengeRewardResultInBound = Class(EventChallengeRewardResultInBound)

function EventChallengeRewardResultInBound:Ctor(buffer)
    --- @type BattleResultInBound
    self.battleResultInBound = nil

    if buffer then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventChallengeRewardResultInBound:ReadBuffer(buffer)
    self.battleResultInBound = BattleResultInBound.CreateByBuffer(buffer)

    self.listReward = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)

    self.battleDamage = buffer:GetInt()
end