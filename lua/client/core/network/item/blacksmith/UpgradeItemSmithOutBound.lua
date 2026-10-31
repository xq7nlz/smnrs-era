require "lua.client.core.network.item.blackSmith.UpgradeEquipmentSmithOutBound"
require "lua.client.core.network.item.blackSmith.UpgradeArtifactSmithOutBound"

--- @class UpgradeItemSmithOutBound : OutBound
UpgradeItemSmithOutBound = Class(UpgradeItemSmithOutBound, OutBound)

--- @return void
function UpgradeItemSmithOutBound:Ctor()
    --- @type List
    self.listDataEquipment = List()
    ----- @type List
    --self.listDataArtifact = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function UpgradeItemSmithOutBound:Serialize(buffer)
    self.listDataEquipment:SortWithMethod(UpgradeItemSmithOutBound._SortIdItem)
    buffer:PutByte(self.listDataEquipment:Count())
    for i = 1, self.listDataEquipment:Count() do
        ---@type UpgradeEquipmentSmithOutBound
        local item = self.listDataEquipment:Get(i)
        --XDebug.Log(LogUtils.ToDetail(item))
        item:Serialize(buffer)
    end
    --buffer:PutByte(self.listDataArtifact:Count())
    --for i = 1, self.listDataArtifact:Count() do
    --    ---@type UpgradeArtifactSmithOutBound
    --    local item = self.listDataArtifact:Get(i)
    --    item:Serialize(buffer)
    --end
end


--- @return number
function UpgradeItemSmithOutBound._SortIdItem(x, y)
    if y.idItem > x.idItem then
        return -1
    else
        return 1
    end
end