--- @class BleedEffect : DotEffect
BleedEffect = Class(BleedEffect, DotEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function BleedEffect:Ctor(initiator, target)
    DotEffect.Ctor(self, initiator, target, EffectType.BLEED)
end

--- @return BleedEffectResult
function BleedEffect:CreateEffectResult()
    return BleedEffectResult(self.initiator, self.myHero, self.duration)
end

--- @return TakeDamageReason
function BleedEffect:GetTakeDamageReason()
    return TakeDamageReason.BLEED
end


