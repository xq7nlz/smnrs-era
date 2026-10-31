--- @class BattlePassExchangeInBound
BattlePassExchangeInBound = Class(BattlePassExchangeInBound)

function BattlePassExchangeInBound:Ctor(buffer)
    --- @type number
    self.sizeOfRewardList = nil
    --- @type
    self.rewardList = List()

    if buffer then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function BattlePassExchangeInBound:ReadBuffer(buffer)
    local sizeOfRewardList = buffer:GetByte()
    for i = 1, sizeOfRewardList do
        local data = BattlePassExchangeInBound(buffer)
        self.rewardList:Add(data)
    end
end