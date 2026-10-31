--- @class ComposeMailOutBound : OutBound
ComposeMailOutBound = Class(ComposeMailOutBound, OutBound)

--- @return void
function ComposeMailOutBound:Ctor()
    ---@type string
    self.subject = nil
    ---@type string
    self.content = nil
    ---@type List
    self.listId = List()
end

--- @return void
function ComposeMailOutBound:SetId(id)
    self.listId:Clear()
    self.listId:Add(id)
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ComposeMailOutBound:Serialize(buffer)
    buffer:PutString(self.subject, false)
    buffer:PutString(self.content, false)
    buffer:PutByte(self.listId:Count())
    for i = 1, self.listId:Count() do
        buffer:PutLong(self.listId:Get(i))
    end
end