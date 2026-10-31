--- @class HeroForHireOutBound : OutBound
HeroForHireOutBound = Class(HeroForHireOutBound, OutBound)

--- @return void
function HeroForHireOutBound:Ctor()
    ---@type List
    self.dataList = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function HeroForHireOutBound:Serialize(buffer)
    buffer:PutByte(self.dataList:Count())
    for i = 1, self.dataList:Count() do
        buffer:PutLong(self.dataList:Get(i))
    end
end