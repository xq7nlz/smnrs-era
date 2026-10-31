--- @class ResetRaiseHeroOutbound : OutBound
ResetRaiseHeroOutbound = Class(ResetRaiseHeroOutbound, OutBound)

--- @return void
function ResetRaiseHeroOutbound:Ctor()
    ---@type List
    self.resetList = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ResetRaiseHeroOutbound:Serialize(buffer)
    buffer:PutByte(self.resetList:Count())
    for i = 1, self.resetList:Count() do
        local data = self.resetList:Get(i)
        buffer:PutByte(data)
    end
end