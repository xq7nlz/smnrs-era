--- @class DungeonBindingOutBound : OutBound
DungeonBindingHeroOutBound = Class(DungeonBindingHeroOutBound, OutBound)

--- @return void
--- @param listData List<heroInventoryId:Number>
function DungeonBindingHeroOutBound:Ctor(listData)
    assert(listData)
    --- @type List
    self.listData = listData
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function DungeonBindingHeroOutBound:Serialize(buffer)
    buffer:PutByte(self.listData:Count())
    for i, v in ipairs(self.listData:GetItems()) do
        buffer:PutLong(v)
    end
end