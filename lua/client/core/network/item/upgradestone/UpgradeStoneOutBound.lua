--- @class UpgradeStoneOutBound : OutBound
UpgradeStoneOutBound = Class(UpgradeStoneOutBound, OutBound)

--- @return void
---@param heroInventoryId number
---@param isKeepProperty boolean
function UpgradeStoneOutBound:Ctor(heroInventoryId, isKeepProperty)
    --- @type number
    self.heroInventoryId = heroInventoryId
    --- @type boolean
    self.isKeepProperty = isKeepProperty
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function UpgradeStoneOutBound:Serialize(buffer)
    buffer:PutLong(self.heroInventoryId)
    buffer:PutBool(self.isKeepProperty)
end