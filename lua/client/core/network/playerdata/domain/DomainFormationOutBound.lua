--- @class DomainFormationOutBound : OutBound
DomainFormationOutBound = Class(DomainFormationOutBound, OutBound)

function DomainFormationOutBound:Ctor(buffer)
    --- @type List
    self.listInventoryId = List()
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function DomainFormationOutBound:ReadBuffer(buffer)
    self.listInventoryId:Clear()
    local size = buffer:GetByte()
    for i = 1, size do
        self.listInventoryId:Add(buffer:GetLong())
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function DomainFormationOutBound:Serialize(buffer)
    buffer:PutByte(self.listInventoryId:Count())
    for _, id in ipairs(self.listInventoryId:GetItems()) do
        buffer:PutLong(id)
    end
end