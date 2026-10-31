--- @class MoneyInBound
MoneyInBound = Class(MoneyInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function MoneyInBound:Ctor(buffer)
    --- @type MoneyType
    self.moneyType = buffer:GetShort()
    --- @type number
    self.value = buffer:GetLong()
end