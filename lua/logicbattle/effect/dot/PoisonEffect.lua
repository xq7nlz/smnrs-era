--- @class PoisonEffect : DotEffect
PoisonEffect = Class(PoisonEffect, DotEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function PoisonEffect:Ctor(initiator, target)
    DotEffect.Ctor(self, initiator, target, EffectType.POISON)
end

--- @return PoisonEffectResult
function PoisonEffect:CreateEffectResult()
    return PoisonEffectResult(self.initiator, self.myHero, self.duration)
end

--- @return TakeDamageReason
function PoisonEffect:GetTakeDamageReason()
    return TakeDamageReason.POISON
end