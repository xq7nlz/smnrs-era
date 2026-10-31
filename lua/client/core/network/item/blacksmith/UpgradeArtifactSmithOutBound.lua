require "lua.client.core.network.item.upgradeItemHeroInfo.UpgradeArtifactInfoMaterialOutBound"

--- @class UpgradeArtifactSmithOutBound : OutBound
UpgradeArtifactSmithOutBound = Class(UpgradeArtifactSmithOutBound, OutBound)

--- @return void
function UpgradeArtifactSmithOutBound:Ctor()
    ---@type number
    self.idItem = nil
    --- @type List
    self.listData = nil
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function UpgradeArtifactSmithOutBound:Serialize(buffer)
    buffer:PutInt(self.idItem)
    buffer:PutByte(self.listData:Count())
    for i = 1, self.listData:Count() do
        ---@type UpgradeArtifactInfoMaterialOutBound
        local item = self.listData:Get(1)
        item:Serialize(buffer)
    end
end