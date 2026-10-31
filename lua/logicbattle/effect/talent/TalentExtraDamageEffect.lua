--- @class TalentExtraDamageEffect : BaseEffect
TalentExtraDamageEffect = Class(TalentExtraDamageEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function TalentExtraDamageEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.TALENT_EXTRA_DAMAGE, true)

    --- @type EffectPersistentType
    self.persistentType = EffectPersistentType.MANUAL_REMOVE
end
