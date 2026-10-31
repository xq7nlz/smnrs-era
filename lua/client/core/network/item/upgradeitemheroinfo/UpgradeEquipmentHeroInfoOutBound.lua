--- @class UpgradeEquipmentHeroInfoOutBound : OutBound
UpgradeEquipmentHeroInfoOutBound = Class(UpgradeEquipmentHeroInfoOutBound, OutBound)

--- @return void
---@param heroInventoryId number
---@param idItem number
function UpgradeEquipmentHeroInfoOutBound:Ctor(heroInventoryId, idItem)
    --- @type number
    self.heroInventoryId = heroInventoryId
    --- @type number
    self.idItem = idItem
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function UpgradeEquipmentHeroInfoOutBound:Serialize(buffer)
    buffer:PutLong(self.heroInventoryId)
    buffer:PutInt(self.idItem)
end