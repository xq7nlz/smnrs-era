--- @class SellItemRecordOutBound : OutBound
SellItemRecordOutBound = Class(SellItemRecordOutBound, OutBound)

--- @return void
function SellItemRecordOutBound:Ctor(idItem, number)
    --- @type number
    self.idItem = idItem
    --- @type number
    self.number = number
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SellItemRecordOutBound:Serialize(buffer)
    buffer:PutInt(self.idItem)
    buffer:PutShort(self.number)
end