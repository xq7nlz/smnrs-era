--- @class HeroLevelUpInBound
HeroLevelUpInBound = Class(HeroLevelUpInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function HeroLevelUpInBound:Ctor(buffer)
    ---@type number
    self.heroInventoryId = buffer:GetLong()
    ---@type number
    self.level = buffer:GetShort()
end

--- @return void
function HeroLevelUpInBound:ToString()
    return LogUtils.ToDetail(self)
end