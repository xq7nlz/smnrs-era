--- @class ReverseShield : BaseEffect
ReverseShield = Class(ReverseShield, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function ReverseShield:Ctor(initiator, target, bonusPercent)
    BaseEffect.Ctor(self, initiator, target, EffectType.REVERSE_SHIELD, true)
    self:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)

    --- @type number
    self.bonusPercent = bonusPercent

    --- @type number
    self.healAmount = 0
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function ReverseShield:OnEffectAdd(target)
    target.effectController.effectListener:Register(EffectListenerType.TAKE_BASIC_ATTACK_DAMAGE, self)
    target.effectController.effectListener:Register(EffectListenerType.TAKE_SKILL_DAMAGE, self)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function ReverseShield:OnEffectRemove(target)
    target.effectController.effectListener:Unregister(EffectListenerType.TAKE_BASIC_ATTACK_DAMAGE, self)
    target.effectController.effectListener:Unregister(EffectListenerType.TAKE_SKILL_DAMAGE, self)
end

--- @return number delta of damage
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function ReverseShield:OnBeAttacked(enemyAttacker, totalDamage)
    if self.healAmount > 0 then
        HealUtils.Heal(self.myHero, self.myHero, self.healAmount, HealReason.LIGHT_SHIELD)
    end
    return BaseEffect.OnBeAttacked(self, enemyAttacker, totalDamage)
end

--- @return number delta of damage
--- @param enemy BaseHero
--- @param totalDamage number
function ReverseShield:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.healAmount > 0 then
        HealUtils.Heal(self.myHero, self.myHero, self.healAmount, HealReason.LIGHT_SHIELD)
    end
    return BaseEffect.OnTakeSkillDamageFromEnemy(self, enemy, totalDamage)
end

--- @return number delta of damage
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function ReverseShield:OnShieldTakeDamage(initiator, reason, damage)
    local healAmount = damage * self.bonusPercent
    if reason ~= TakeDamageReason.ATTACK_DAMAGE and reason ~= TakeDamageReason.SKILL_DAMAGE then
        HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.REVERSE_SHIELD)
        self.healAmount = 0
    else
        self.healAmount = healAmount
    end
    return -damage * self.bonusPercent
end

--- @return string
function ReverseShield:ToDetailString()
    return string.format("%s, BONUS_HEAL = %s", self:ToString(), self.bonusPercent)
end

