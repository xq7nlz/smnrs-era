--- @class UnbindingRaiseHeroOutbound : OutBound
UnbindingRaiseHeroOutbound = Class(UnbindingRaiseHeroOutbound, OutBound)

--- @return void
function UnbindingRaiseHeroOutbound:Ctor()
    ---@type List
    self.slotList = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function UnbindingRaiseHeroOutbound:Serialize(buffer)
    buffer:PutByte(self.slotList:Count())
    for i = 1, self.slotList:Count() do
        local data = self.slotList:Get(i)
        buffer:PutByte(data)
    end
end