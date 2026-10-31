--- @class TalentCriticalSilentEffect : BaseEffect
TalentCriticalSilentEffect = Class(TalentCriticalSilentEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function TalentCriticalSilentEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.TALENT_CRITICAL_SILENT, true)

    self.persistentType = EffectPersistentType.MANUAL_REMOVE
end