--- @class BlossomDayLuckyWishResult
BlossomDayLuckyWishResult = Class(BlossomDayLuckyWishResult)

function BlossomDayLuckyWishResult:Ctor(buffer)
   -- self.logicCode = buffer:GetShort()
    self.rewards = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
    self.listPosition = List()
    local size = buffer:GetByte()
    for i = 1, size do
        self.listPosition:Add(buffer:GetInt())
    end
end
