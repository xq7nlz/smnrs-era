--- @class WeaknessPoint : BaseEffect
WeaknessPoint = Class(WeaknessPoint, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function WeaknessPoint:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.WEAKNESS_POINT, false)
end