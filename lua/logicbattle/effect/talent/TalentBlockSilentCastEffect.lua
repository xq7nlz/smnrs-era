--- @class TalentBlockSilentCastEffect : BaseEffect
TalentBlockSilentCastEffect = Class(TalentBlockSilentCastEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function TalentBlockSilentCastEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.TALENT_BLOCK_SILENT_CAST, true)

    self.persistentType = EffectPersistentType.MANUAL_REMOVE
end

function TalentBlockSilentCastEffect:IsTrigger(type)
    return type == EffectType.SILENCE
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function TalentBlockSilentCastEffect:OnEffectRemove(target)
    local markEffect = TalentBlockSilentEffect(self.myHero, self.myHero)
    self.myHero.effectController:AddEffect(markEffect)
end


--- @return void
--- @param target BaseHero
function TalentBlockSilentCastEffect:OnEffectAdd(target)
    local blockSilentEffect =  self.myHero.effectController:GetDistinctEffectWithType(EffectType.TALENT_BLOCK_SILENT)
    if blockSilentEffect ~= nil then
        self.myHero.effectController:ForceRemove(blockSilentEffect)
    end
end