--- @class CombineArtifactRecordOutBound : OutBound
CombineArtifactRecordOutBound = Class(CombineArtifactRecordOutBound, OutBound)

--- @return void
function CombineArtifactRecordOutBound:Ctor(idItem, number)
    --- @type number
    self.idItem = idItem
    --- @type number
    self.number = number
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function CombineArtifactRecordOutBound:Serialize(buffer)
    buffer:PutInt(self.idItem)
    buffer:PutShort(self.number)
end