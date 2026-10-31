--- @class WaterFriendly : BaseEffect
WaterFriendly = Class(WaterFriendly, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function WaterFriendly:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.WATER_FRIENDLY, true)
end