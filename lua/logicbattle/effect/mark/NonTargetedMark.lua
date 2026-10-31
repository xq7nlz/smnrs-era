--- @class NonTargetedMark : BaseEffect
NonTargetedMark = Class(NonTargetedMark, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function NonTargetedMark:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.NON_TARGETED_MARK, true)
    self:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)
end