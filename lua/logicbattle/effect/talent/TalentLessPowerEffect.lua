--- @class TalentLessPowerEffect : BaseEffect
TalentLessPowerEffect = Class(TalentLessPowerEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function TalentLessPowerEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.TALENT_LESS_POWER, true)

    self.persistentType = EffectPersistentType.MANUAL_REMOVE
end