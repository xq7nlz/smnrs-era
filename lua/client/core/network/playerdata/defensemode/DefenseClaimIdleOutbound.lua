--- @class DefenseClaimIdleOutbound : OutBound
DefenseClaimIdleOutbound = Class(DefenseClaimIdleOutbound, OutBound)

--- @return void
function DefenseClaimIdleOutbound:Ctor()
    self.listLand = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function DefenseClaimIdleOutbound:Serialize(buffer)
    buffer:PutByte(self.listLand:Count())
    for _, land in ipairs(self.listLand:GetItems()) do
        buffer:PutShort(land)
    end
end