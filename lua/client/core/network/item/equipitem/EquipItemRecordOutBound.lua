--- @class EquipItemRecordOutBound : OutBound
EquipItemRecordOutBound = Class(EquipItemRecordOutBound, OutBound)

--- @return void
function EquipItemRecordOutBound:Ctor(heroInventoryId, heroItemSlot, idItem)
    --- @type number
    self.heroInventoryId = heroInventoryId
    --- @type number
    self.heroItemSlot = heroItemSlot
    --- @type number
    self.idItem = idItem
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function EquipItemRecordOutBound:Serialize(buffer)
    buffer:PutLong(self.heroInventoryId)
    buffer:PutByte(self.heroItemSlot)
    buffer:PutInt(self.idItem)
end