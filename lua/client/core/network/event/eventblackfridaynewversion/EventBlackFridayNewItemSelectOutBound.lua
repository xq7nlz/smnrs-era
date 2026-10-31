--- @class EventBlackFridayNewItemSelectOutBound : OutBound
EventBlackFridayNewItemSelectOutBound = Class(EventBlackFridayNewItemSelectOutBound, OutBound)

--- @return void
function EventBlackFridayNewItemSelectOutBound:Ctor()
    ---@type List<number>
    self.selectItems = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function EventBlackFridayNewItemSelectOutBound:Serialize(buffer)
    local size = self.selectItems:Count()
    buffer:PutByte(size)

    ---@param v EventBlackFridayNewItemSelectOutBound
    for _, v in ipairs(self.selectItems:GetItems()) do
        buffer:PutInt(v)
    end
end