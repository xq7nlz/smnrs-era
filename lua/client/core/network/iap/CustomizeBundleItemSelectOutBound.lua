--- @class CustomizeBundleItemSelectOutBound : OutBound
CustomizeBundleItemSelectOutBound = Class(CustomizeBundleItemSelectOutBound, OutBound)

--- @return void
function CustomizeBundleItemSelectOutBound:Ctor(id)
    ---@type number
    self.packId = id
    ---@type List<number>
    self.selectItems = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function CustomizeBundleItemSelectOutBound:Serialize(buffer)
    buffer:PutInt(self.packId)
    local size = self.selectItems:Count()
    buffer:PutByte(size)

    ---@param v CustomizeBundleItemSelectOutBound
    for _, v in ipairs(self.selectItems:GetItems()) do
        buffer:PutInt(v)
    end
end