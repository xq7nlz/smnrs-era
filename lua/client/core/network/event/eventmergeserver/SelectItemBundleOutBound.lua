--- @class SelectItemBundleOutBound : OutBound
SelectItemBundleOutBound = Class(SelectItemBundleOutBound, OutBound)

--- @return void
function SelectItemBundleOutBound:Ctor(packId, listItem)
    ---@type BattleFormationOutBound
    self.packId = packId
    ---@type List
    self.listItem = listItem
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SelectItemBundleOutBound:Serialize(buffer)
    buffer:PutInt(self.packId)
    buffer:PutByte(self.listItem:Count())
    for i, v in ipairs(self.listItem:GetItems()) do
        buffer:PutInt(v)
    end
end