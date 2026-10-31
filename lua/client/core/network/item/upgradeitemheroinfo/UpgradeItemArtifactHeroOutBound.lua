require "lua.client.core.network.item.upgradeItemHeroInfo.UpgradeArtifactHeroInfoOutBound"

--- @class UpgradeItemArtifactHeroOutBound : OutBound
UpgradeItemArtifactHeroOutBound = Class(UpgradeItemArtifactHeroOutBound, OutBound)

--- @return void
function UpgradeItemArtifactHeroOutBound:Ctor()
    --- @type List
    self.listDataArtifact = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function UpgradeItemArtifactHeroOutBound:Serialize(buffer)
    buffer:PutByte(self.listDataArtifact:Count())
    for i = 1, self.listDataArtifact:Count() do
        ---@type UpgradeArtifactHeroInfoOutBound
        local item = self.listDataArtifact:Get(i)
        item:Serialize(buffer)
    end
end