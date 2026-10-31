--- @class HealResistanceEffect : BaseEffect
HealResistanceEffect = Class(HealResistanceEffect, BaseEffect)

function HealResistanceEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.RESIST_HEAL, false)
end