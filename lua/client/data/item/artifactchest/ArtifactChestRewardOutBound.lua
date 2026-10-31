--- @class ArtifactChestRewardOutbound : OutBound
ArtifactChestRewardOutbound = Class(ArtifactChestRewardOutbound, OutBound)

--- @return void
function ArtifactChestRewardOutbound:Ctor(chestId, number, selectedItemsList)
    --- @type number
    self.chestId = chestId
    --- @type number
    self.number = number
    ---@type List
    self.selectedItemsList = selectedItemsList
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArtifactChestRewardOutbound:Serialize(buffer)
    buffer:PutInt(self.chestId)
    buffer:PutInt(self.number)
    buffer:PutByte(self.selectedItemsList:Count())
    for index,value in ipairs(self.selectedItemsList:GetItems()) do
        buffer:PutInt(index)
        buffer:PutInt(value.selectionId)
    end
end