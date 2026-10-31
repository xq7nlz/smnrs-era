--- @class TalentInstantKillEffect : BaseEffect
TalentInstantKillEffect = Class(TalentInstantKillEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function TalentInstantKillEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.TALENT_INSTANT_KILL, true)

    self.persistentType = EffectPersistentType.MANUAL_REMOVE
end