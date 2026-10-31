--- @class UpgradeArtifactHeroInfoOutBound : OutBound
UpgradeArtifactHeroInfoOutBound = Class(UpgradeArtifactHeroInfoOutBound, OutBound)

--- @return void
---@param heroInventoryId number
---@param itemDict Dictionary
function UpgradeArtifactHeroInfoOutBound:Ctor(heroInventoryId, itemDict)
    --- @type number
    self.heroInventoryId = heroInventoryId
    --- @type Dictionary
    self.itemDict = itemDict
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function UpgradeArtifactHeroInfoOutBound:Serialize(buffer)
    buffer:PutLong(self.heroInventoryId)
    buffer:PutByte(self.itemDict:Count())
    for i, v in pairs(self.itemDict:GetItems()) do
        buffer:PutInt(i)
        buffer:PutShort(v)
    end
end