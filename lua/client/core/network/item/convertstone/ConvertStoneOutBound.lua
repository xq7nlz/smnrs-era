--- @class ConvertStoneOutBound : OutBound
ConvertStoneOutBound = Class(ConvertStoneOutBound, OutBound)

--- @return void
---@param heroInventoryId number
function ConvertStoneOutBound:Ctor(heroInventoryId, numberConvert)
    --- @type number
    self.heroInventoryId = heroInventoryId
    --- @type number
    self.numberConvert = numberConvert
    --- @type List
    self.listData = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ConvertStoneOutBound:Serialize(buffer)
    buffer:PutLong(self.heroInventoryId)
    buffer:PutByte(self.numberConvert)
end