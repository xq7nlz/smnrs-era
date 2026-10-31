--- @class DarkMark : BaseEffect
DarkMark = Class(DarkMark, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function DarkMark:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.DARK_MARK, false)
end