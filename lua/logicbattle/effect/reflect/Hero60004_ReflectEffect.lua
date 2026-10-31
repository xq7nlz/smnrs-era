--- @class Hero60004_ReflectEffect : BaseEffect
Hero60004_ReflectEffect = Class(Hero60004_ReflectEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function Hero60004_ReflectEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.REFLECT, false)
    self:SetPersistentType(EffectPersistentType.MANUAL_REMOVE)
end

--- @return string
function Hero60004_ReflectEffect:ToDetailString()
    return string.format("%s, REFLECT EFFECT", self:ToString())
end
