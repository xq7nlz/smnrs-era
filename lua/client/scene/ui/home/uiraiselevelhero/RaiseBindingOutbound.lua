--- @class RaiseBindingOutbound : OutBound
RaiseBindingOutbound = Class(RaiseBindingOutbound, OutBound)

--- @return void
function RaiseBindingOutbound:Ctor()
    ---@type Dictionary
    self.bindingDict = Dictionary()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function RaiseBindingOutbound:Serialize(buffer)
    buffer:PutByte(self.bindingDict:Count())
    for k, v in pairs(self.bindingDict:GetItems()) do
        buffer:PutByte(k)
        buffer:PutLong(v)
    end
end