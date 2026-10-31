require "lua.client.core.network.playerData.common.BattleResultInBound"

--- @class EventAiryuuTrialInBound
EventAiryuuTrialInBound = Class(EventAiryuuTrialInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function EventAiryuuTrialInBound:Ctor(buffer)
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventAiryuuTrialInBound:ReadBuffer(buffer)
    self.battleResultInfo = BattleResultInBound.CreateByBuffer(buffer, true)
    self.listReward = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
end

function EventAiryuuTrialInBound:GetChallengeReward()
    return self.listReward
end