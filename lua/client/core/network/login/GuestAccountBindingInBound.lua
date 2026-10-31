--- @class GuestAccountBindingInBound
GuestAccountBindingInBound = Class(GuestAccountBindingInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function GuestAccountBindingInBound:Ctor(buffer)
    local size = buffer:GetByte()
    ---@type List
    self.listUserName = List()
    for i = 1, size do
        self.listUserName:Add(buffer:GetString())
    end
end

--- @return void
function GuestAccountBindingInBound:ToString()
    return LogUtils.ToDetail(self.listUserName:GetItems())
end