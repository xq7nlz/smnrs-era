--- @class Hero30003_ClonePuppet : BaseEffect
Hero30003_ClonePuppet = Class(Hero30003_ClonePuppet, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function Hero30003_ClonePuppet:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.NERO_CLONE_PUPPET, true)
    self:SetPersistentType(EffectPersistentType.MANUAL_REMOVE)
end