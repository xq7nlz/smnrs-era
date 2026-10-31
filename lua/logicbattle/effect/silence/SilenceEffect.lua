--- @class SilenceEffect : BaseEffect
SilenceEffect = Class(SilenceEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function SilenceEffect:Ctor(initiator, target, duration)
    BaseEffect.Ctor(self, initiator, target, EffectType.SILENCE, false)
    BaseEffect.SetDuration(self, duration)
end