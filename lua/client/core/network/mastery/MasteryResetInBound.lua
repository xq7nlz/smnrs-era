--- @class MasteryResetInBound
MasteryResetInBound = Class(MasteryResetInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function MasteryResetInBound:Ctor(buffer)
    ---@type number
    self.heroClassType = buffer:GetByte()
    ---@type number
    self.masteryId = buffer:GetByte()
end

--- @return void
function MasteryResetInBound:ToString()
    return LogUtils.ToDetail(self)
end