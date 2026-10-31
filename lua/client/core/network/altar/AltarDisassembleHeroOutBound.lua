
--- @class AltarDisassembleHeroOutBound : OutBound
AltarDisassembleHeroOutBound = Class(AltarDisassembleHeroOutBound, OutBound)

--- @return void
---@param listHeroInventoryId List
function AltarDisassembleHeroOutBound:Ctor(listHeroInventoryId)
    ---@type List
    self.listHeroInventoryId = listHeroInventoryId
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function AltarDisassembleHeroOutBound:Serialize(buffer)
    buffer:PutByte(self.listHeroInventoryId:Count())
    for _, inventoryId in pairs(self.listHeroInventoryId:GetItems()) do
        buffer:PutLong(inventoryId)
    end
end