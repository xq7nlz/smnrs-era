--- @class TalentBlockSilentEffect : BaseEffect
TalentBlockSilentEffect = Class(TalentBlockSilentEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function TalentBlockSilentEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.TALENT_BLOCK_SILENT, true)

    self.persistentType = EffectPersistentType.MANUAL_REMOVE
end