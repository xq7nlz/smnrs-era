--- @class MasteryUpgradeInBound
MasteryUpgradeInBound = Class(MasteryUpgradeInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function MasteryUpgradeInBound:Ctor(buffer)
    ---@type number
    self.heroClassType = buffer:GetByte()
    ---@type number
    self.masteryId = buffer:GetByte()
    ---@type number
    self.targetLevel = buffer:GetByte()
end

--- @return void
function MasteryUpgradeInBound:ToString()
    return LogUtils.ToDetail(self)
end