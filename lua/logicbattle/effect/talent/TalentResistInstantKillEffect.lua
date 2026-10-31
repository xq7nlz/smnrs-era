--- @class TalentResistInstantKillEffect : BaseEffect
TalentResistInstantKillEffect = Class(TalentResistInstantKillEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function TalentResistInstantKillEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.TALENT_RESIST_INSTANT_KILL, true)

    self.persistentType = EffectPersistentType.MANUAL_REMOVE
end