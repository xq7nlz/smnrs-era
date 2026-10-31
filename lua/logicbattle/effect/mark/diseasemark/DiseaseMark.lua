--- @class DiseaseMark : BaseEffect
DiseaseMark = Class(DiseaseMark, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function DiseaseMark:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.DISEASE_MARK, false)
    self:SetPersistentType(EffectPersistentType.LOST_WHEN_REVIVE)
end