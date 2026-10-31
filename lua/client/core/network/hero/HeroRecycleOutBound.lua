
--- @class HeroRecycleOutBound : OutBound
HeroRecycleOutBound = Class(HeroRecycleOutBound, OutBound)

--- @return void
function HeroRecycleOutBound:Ctor()
    --- @type List
    self.listHeroInventory = List()
    --- @type List
    self.listFoodId = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function HeroRecycleOutBound:Serialize(buffer)
    buffer:PutByte(self.listHeroInventory:Count())
    for i = 1, self.listHeroInventory:Count() do
        local item = self.listHeroInventory:Get(i)
        buffer:PutLong(item)
    end
    buffer:PutByte(self.listFoodId:Count())
    for i = 1, self.listFoodId:Count() do
        local item = self.listFoodId:Get(i)
        buffer:PutInt(item)
    end
end