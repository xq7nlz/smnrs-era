--- @class LotteryResult
LotteryResult = Class(LotteryResult)

function LotteryResult:Ctor(buffer)
   -- self.logicCode = buffer:GetShort()
    self.rewards = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
    self.idLotteryReward = buffer:GetByte()
end
