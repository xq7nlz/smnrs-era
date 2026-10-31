require "lua.client.core.network.item.combineArtifact.CombineArtifactRecordOutBound"

--- @class CombineArtifactFragmentOutBound : OutBound
CombineArtifactFragmentOutBound = Class(CombineArtifactFragmentOutBound, OutBound)

--- @return void
function CombineArtifactFragmentOutBound:Ctor()
    --- @type List --<CombineArtifactRecordOutBound>
    self.listData = List()
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function CombineArtifactFragmentOutBound:Serialize(buffer)
    buffer:PutByte(self.listData:Count())
    for i = 1, self.listData:Count() do
        ---@type CombineArtifactRecordOutBound
        local item = self.listData:Get(1)
        item:Serialize(buffer)
    end
end