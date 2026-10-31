--- @class BloodMark : BaseEffect
BloodMark = Class(BloodMark, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param duration number
function BloodMark:Ctor(initiator, target, duration)
    BaseEffect.Ctor(self, initiator, target, EffectType.BLOOD_MARK, false)
    BaseEffect.SetDuration(self, duration)
end