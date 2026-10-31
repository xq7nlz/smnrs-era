--- @class LuckyWishResult
LuckyWishResult = Class(LuckyWishResult)

function LuckyWishResult:Ctor(buffer)
   -- self.logicCode = buffer:GetShort()
    self.rewards = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
    self.listPosition = List()
    local size = buffer:GetByte()
    for i = 1, size do
        self.listPosition:Add(buffer:GetInt())
    end
end
