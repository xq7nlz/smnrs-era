require "lua.client.core.network.item.equipItem.EquipItemRecordOutBound"

--- @class EquipItemOutBound : OutBound
EquipItemOutBound = Class(EquipItemOutBound, OutBound)

--- @return void
function EquipItemOutBound:Ctor()
    --- @type List
    self.listData = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function EquipItemOutBound:Serialize(buffer)
    buffer:PutByte(self.listData:Count())
    for i = 1, self.listData:Count() do
        ---@type EquipItemRecordOutBound
        local item = self.listData:Get(i)
        --XDebug.Log(LogUtils.ToDetail(item))
        item:Serialize(buffer)
    end
end