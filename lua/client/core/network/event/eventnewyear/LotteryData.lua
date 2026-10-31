--- @class LotteryData
LotteryData = Class(LotteryData)

function LotteryData:Ctor(buffer)
    self.openedRewardIds = List()
    self:ReadBuffer(buffer)
end

--- @param buffer UnifiedNetwork_ByteBuf
function LotteryData:ReadBuffer(buffer)
    self.numberRoll = buffer:GetInt()
    local size = buffer:GetByte()
    for i = 1, size do
        self.openedRewardIds:Add(buffer:GetByte())
    end
end
