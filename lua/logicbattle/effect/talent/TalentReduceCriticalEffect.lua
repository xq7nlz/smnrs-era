--- @class TalentReduceCriticalEffect : BaseEffect
TalentReduceCriticalEffect = Class(TalentReduceCriticalEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function TalentReduceCriticalEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.TALENT_REDUCE_CRITICAL, true)

    self.persistentType = EffectPersistentType.MANUAL_REMOVE
end