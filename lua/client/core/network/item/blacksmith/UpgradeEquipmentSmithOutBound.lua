--- @class UpgradeEquipmentSmithOutBound : OutBound
UpgradeEquipmentSmithOutBound = Class(UpgradeEquipmentSmithOutBound, OutBound)

--- @return void
function UpgradeEquipmentSmithOutBound:Ctor(idItem, number)
    --- @type number
    self.idItem = idItem
    --- @type number
    self.number = number
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function UpgradeEquipmentSmithOutBound:Serialize(buffer)
    buffer:PutInt(self.idItem)
    buffer:PutShort(self.number)
end