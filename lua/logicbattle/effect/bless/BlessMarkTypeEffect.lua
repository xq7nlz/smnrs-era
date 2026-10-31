--- @class BlessMarkTypeEffect : BaseEffect
BlessMarkTypeEffect = Class(BlessMarkTypeEffect, BlessMarkEffect)

--- @return boolean
--- @param blessType EffectType
function BlessMarkTypeEffect:SetCurseMarkType(blessType)
    self.blessType = blessType
end

--- @return boolean
--- @param effectType EffectType
function BlessMarkTypeEffect:IsTrigger(effectType)
    if self.blessType == effectType then
        return true
    end
    return false
end

--- @return string
function BlessMarkTypeEffect:ToDetailString()
    return string.format("%s, BLESS_TYPE = %s", self:ToString(), self.blessType)
end
