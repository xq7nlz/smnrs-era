require "lua.client.core.network.item.upgradeItemHeroInfo.UpgradeEquipmentHeroInfoOutBound"

--- @class UpgradeItemEquipHeroOutBound : OutBound
UpgradeItemEquipHeroOutBound = Class(UpgradeItemEquipHeroOutBound, OutBound)

--- @return void
function UpgradeItemEquipHeroOutBound:Ctor()
    --- @type List
    self.listDataEquipment = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function UpgradeItemEquipHeroOutBound:Serialize(buffer)
    buffer:PutByte(self.listDataEquipment:Count())
    for i = 1, self.listDataEquipment:Count() do
        ---@type UpgradeEquipmentHeroInfoOutBound
        local item = self.listDataEquipment:Get(i)
        item:Serialize(buffer)
    end
end