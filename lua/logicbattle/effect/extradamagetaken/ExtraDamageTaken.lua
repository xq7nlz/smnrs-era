--- @class ExtraDamageTaken : BaseEffect
ExtraDamageTaken = Class(ExtraDamageTaken, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function ExtraDamageTaken:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.EXTRA_DAMAGE_TAKEN, false)

    --- @type number
    self.damageReceive = 0
end

--- @return void
--- @param damageReceive number
function ExtraDamageTaken:SetDamageReceiveDebuffAmount(damageReceive)
    self.damageReceive = damageReceive
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function ExtraDamageTaken:OnEffectAdd(target)
    target.effectController.effectListener:Register(EffectListenerType.TAKE_DAMAGE, self)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function ExtraDamageTaken:OnEffectRemove(target)
    target.effectController.effectListener:Unregister(EffectListenerType.TAKE_DAMAGE, self)
end

--- @return number delta of damage
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function ExtraDamageTaken:OnTakeDamage(initiator, reason, damage)
    return damage * self.damageReceive
end

--- @return string
function ExtraDamageTaken:ToDetailString()
    return string.format("%s, damageReceive = %s", self:ToString(), self.damageReceive)
end