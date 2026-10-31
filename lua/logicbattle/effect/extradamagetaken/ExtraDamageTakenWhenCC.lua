--- @class ExtraDamageTakenWhenCC : ExtraDamageTaken
ExtraDamageTakenWhenCC = Class(ExtraDamageTakenWhenCC, ExtraDamageTaken)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function ExtraDamageTakenWhenCC:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.EXTRA_DAMAGE_TAKEN_WHEN_CC, false)

    --- @type number
    self.damageReceive = 0
end

--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function ExtraDamageTakenWhenCC:OnEffectAdd(target)
    target.effectController.effectListener:Register(EffectListenerType.TAKE_DAMAGE, self)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function ExtraDamageTakenWhenCC:OnEffectRemove(target)
    target.effectController.effectListener:Unregister(EffectListenerType.TAKE_DAMAGE, self)
end

--- @return number delta of damage
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function ExtraDamageTakenWhenCC:OnTakeDamage(initiator, reason, damage)
    if reason == TakeDamageReason.ATTACK_DAMAGE or reason == TakeDamageReason.SKILL_DAMAGE then
        if self.myHero.effectController:IsContainCCEffect() then
            return damage * self.damageReceive
        end
    end
    return 0
end