--- @class BurningEffect : DotEffect
BurningEffect = Class(BurningEffect, DotEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function BurningEffect:Ctor(initiator, target)
    DotEffect.Ctor(self, initiator, target, EffectType.BURN)
end

--- @return BurningEffectResult
function BurningEffect:CreateEffectResult()
    return BurningEffectResult(self.initiator, self.myHero, self.duration)
end

--- @return TakeDamageReason
function BurningEffect:GetTakeDamageReason()
    return TakeDamageReason.BURNING
end

