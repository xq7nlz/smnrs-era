--- @class SaveStoneOutbound : OutBound
SaveStoneOutbound = Class(SaveStoneOutbound, OutBound)

--- @return void
---@param heroInventoryId number
function SaveStoneOutbound:Ctor(heroInventoryId, isSave)
    --- @type number
    self.heroInventoryId = heroInventoryId
    --- @type boolean
    self.isSave = isSave
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SaveStoneOutbound:Serialize(buffer)
    buffer:PutLong(self.heroInventoryId)
    buffer:PutBool(self.isSave)
end