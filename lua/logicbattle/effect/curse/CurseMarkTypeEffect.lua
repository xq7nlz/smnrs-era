--- @class CurseMarkTypeEffect : CurseMarkEffect
CurseMarkTypeEffect = Class(CurseMarkTypeEffect, CurseMarkEffect)

--- @return boolean
--- @param curseType EffectType
function CurseMarkTypeEffect:SetCurseMarkType(curseType)
    self.curseType = curseType
end

--- @return boolean
--- @param effectType EffectType
function CurseMarkTypeEffect:IsTrigger(effectType)
    if self.curseType == effectType then
        return true
    end
    return false
end


--- @return string
function CurseMarkTypeEffect:ToDetailString()
    return string.format("%s, CURSE_TYPE = %s", self:ToString(), self.curseType)
end