--- @class ProgressPackItemSelectOutbound : OutBound
ProgressPackItemSelectOutbound = Class(ProgressPackItemSelectOutbound, OutBound)

--- @return void
function ProgressPackItemSelectOutbound:Ctor(packId, size, selectItems)
    --- @type number
    self.packId = packId
    --- @type number
    self.size = size
    --- @type Dictionary
    self.selectItems = selectItems
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ProgressPackItemSelectOutbound:Serialize(buffer)
    buffer:PutInt(self.packId)
    buffer:PutByte(self.size)
    for i = 1, self.size do
        buffer:PutInt(i)
        buffer:PutInt(self.selectItems:Get(i))
    end
end