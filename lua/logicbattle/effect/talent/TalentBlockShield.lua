--- @class TalentBlockShield : BaseEffect
TalentBlockShield = Class(TalentBlockShield, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param duration number
function TalentBlockShield:Ctor(initiator, target, duration)
    BaseEffect.Ctor(self, initiator, target, EffectType.TALENT_BLOCK_SHIELD, true)

    self.duration = duration

    self.persistentType = EffectPersistentType.EFFECT_SPECIAL_UPDATABLE
end