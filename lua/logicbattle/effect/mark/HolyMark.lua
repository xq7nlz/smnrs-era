--- @class HolyMark : BaseEffect
HolyMark = Class(HolyMark, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function HolyMark:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.HOLY_MARK, false)
end