--- @class ArenaChestOpenOutBound : OutBound
ArenaChestOpenOutBound = Class(ArenaChestOpenOutBound, OutBound)

--- @return void
---@param chestId number
---@param numberOfChest number
---@param rewardDict Dictionary
function ArenaChestOpenOutBound:Ctor(chestId,numberOfChest,rewardDict)
    ---@type number
    self.chestId = chestId
    ---@type number
    self.numberOfChest = numberOfChest
    ---@type Dictionary
    self.rewardDict = rewardDict
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaChestOpenOutBound:Serialize(buffer)
    buffer:PutInt(self.chestId)
    buffer:PutInt(self.numberOfChest)
    buffer:PutByte(self.rewardDict:Count())
    for k, v in pairs(self.rewardDict:GetItems()) do
        buffer:PutInt(k)
        buffer:PutInt(v)
    end
end 