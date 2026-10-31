--- @class TalentMorePowerEffect : BaseEffect
TalentMorePowerEffect = Class(TalentMorePowerEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function TalentMorePowerEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.TALENT_MORE_POWER, true)

    self.persistentType = EffectPersistentType.MANUAL_REMOVE
end