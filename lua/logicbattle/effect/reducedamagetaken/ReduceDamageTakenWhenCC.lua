--- @class ReduceDamageTakenWhenCC : ReduceDamageTaken
ReduceDamageTakenWhenCC = Class(ReduceDamageTakenWhenCC, ReduceDamageTaken)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function ReduceDamageTakenWhenCC:Ctor(initiator, target)
    ReduceDamageTaken.Ctor(self, initiator, target, EffectType.REDUCE_DAMAGE_TAKEN_WHEN_CC, true)
end

--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function ReduceDamageTakenWhenCC:OnEffectAdd(target)
    target.effectController.effectListener:Register(EffectListenerType.TAKE_DAMAGE, self)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function ReduceDamageTakenWhenCC:OnEffectRemove(target)
    target.effectController.effectListener:Unregister(EffectListenerType.TAKE_DAMAGE, self)
end

--- @return number delta of damage
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function ReduceDamageTakenWhenCC:OnTakeDamage(initiator, reason, damage)
    if self.myHero.effectController:IsContainCCEffect() then
        return ReduceDamageTaken.OnTakeDamage(self, initiator, reason, damage)
    end
    return 0
end