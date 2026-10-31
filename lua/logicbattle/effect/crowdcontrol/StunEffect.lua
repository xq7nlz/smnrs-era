--- @class StunEffect : BaseEffect
StunEffect = Class(StunEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function StunEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.STUN, false)
end