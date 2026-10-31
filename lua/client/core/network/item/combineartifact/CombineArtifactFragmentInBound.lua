--- @class CombineArtifactFragmentInBound
CombineArtifactFragmentInBound = Class(CombineArtifactFragmentInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function CombineArtifactFragmentInBound:Ctor(buffer)
    ---@type number
    local size = buffer:GetByte()
    ---@type List  --<number>
    self.listId = List()
    for i = 1, size do
        self.listId:Add(buffer:GetInt())
    end

    --XDebug.Log(self.listId:ToString())
end