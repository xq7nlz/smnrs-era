--- @class UpgradeStoneInBound
UpgradeStoneInBound = Class(UpgradeStoneInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function UpgradeStoneInBound:Ctor(buffer)
    self.stoneId = buffer:GetInt()
end

--- @return void
function UpgradeStoneInBound:ToString()
    return LogUtils.ToDetail(self)
end