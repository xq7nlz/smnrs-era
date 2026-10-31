require "lua.client.core.network.item.sellItem.SellItemRecordOutBound"

--- @class SellItemOutBound : OutBound
SellItemOutBound = Class(SellItemOutBound, OutBound)

--- @return void
function SellItemOutBound:Ctor()
    --- @type List
    self.listData = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SellItemOutBound:Serialize(buffer)
    buffer:PutByte(self.listData:Count())
    for i = 1, self.listData:Count() do
        ---@type SellItemRecordOutBound
        local item = self.listData:Get(i)
        --XDebug.Log(LogUtils.ToDetail(item))
        item:Serialize(buffer)
    end
end