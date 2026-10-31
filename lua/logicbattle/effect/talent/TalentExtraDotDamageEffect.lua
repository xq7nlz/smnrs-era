--- @class TalentExtraDotDamageEffect : BaseEffect
TalentExtraDotDamageEffect = Class(TalentExtraDotDamageEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function TalentExtraDotDamageEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.TALENT_EXTRA_DOT_DAMAGE, true)

    --- @type EffectPersistentType
    self.persistentType = EffectPersistentType.MANUAL_REMOVE
end
