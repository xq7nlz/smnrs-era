--- @class ReduceDamageTaken : BaseEffect
ReduceDamageTaken = Class(ReduceDamageTaken, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param type EffectType
function ReduceDamageTaken:Ctor(initiator, target, type)
    BaseEffect.Ctor(self, initiator, target, type, true)

    --- @type number
    self.damageReduce = 0
end

--- @return void
--- @param damageReceive number
function ReduceDamageTaken:SetDamageReduceAmount(damageReceive)
    self.damageReduce = damageReceive
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function ReduceDamageTaken:OnEffectAdd(target)
    target.effectController.effectListener:Register(EffectListenerType.TAKE_DAMAGE, self)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function ReduceDamageTaken:OnEffectRemove(target)
    target.effectController.effectListener:Unregister(EffectListenerType.TAKE_DAMAGE, self)
end

--- @return number delta of damage
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function ReduceDamageTaken:OnTakeDamage(initiator, reason, damage)
    return -damage * self.damageReduce
end

--- @return string
function ReduceDamageTaken:ToDetailString()
    return string.format("%s, damageReceive = %s", self:ToString(), self.damageReduce)
end