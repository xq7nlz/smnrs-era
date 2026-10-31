--- @class UpgradeArtifactInfoMaterialOutBound : OutBound
UpgradeArtifactInfoMaterialOutBound = Class(UpgradeArtifactInfoMaterialOutBound, OutBound)

--- @return void
---@param idItem number
---@param numberItem number
function UpgradeArtifactInfoMaterialOutBound:Ctor(idItem, numberItem)
    --- @type number
    self.idItem = idItem
    --- @type number
    self.numberItem = numberItem
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function UpgradeArtifactInfoMaterialOutBound:Serialize(buffer)
    buffer:PutInt(self.idItem)
    buffer:PutShort(self.numberItem)
end