--- @class LightShield : BaseEffect
LightShield = Class(LightShield, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function LightShield:Ctor(initiator, target, bonusPercent)
    BaseEffect.Ctor(self, initiator, target, EffectType.LIGHT_SHIELD, true)
    self:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)

    --- @type number
    self.bonusPercent = bonusPercent

    --- @type number
    self.healAmount = 0

    ----- @type EventListener
    local listener = EventListener(initiator, self, self.OnTakeDamage)
    initiator.battle.eventManager:AddListener(EventType.HERO_TAKE_DAMAGE, listener)
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param eventData table
function LightShield:OnTakeDamage(eventData)
    if self.healAmount > 0 and eventData.target == self.myHero then
        HealUtils.Heal(self.initiator, self.myHero, self.healAmount, HealReason.LIGHT_SHIELD)
        self.healAmount = 0
    end
end

--- @return number delta of damage
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function LightShield:OnShieldTakeDamage(initiator, reason, damage)
    local healAmount = damage * self.bonusPercent
    self.healAmount = healAmount

    return -damage * self.bonusPercent
end

--- @return string
function LightShield:ToDetailString()
    return string.format("%s, BONUS_HEAL = %s", self:ToString(), self.bonusPercent)
end

