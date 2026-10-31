--- @class DivineShield : BaseEffect
DivineShield = Class(DivineShield, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function DivineShield:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.DIVINE_SHIELD, true)
    self:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)

    --- @type number
    self.hp = nil

    --- @type boolean
    self.isDecreaseDuration = false
end

--- @return void
--- @param bonusPercent number
--- @param duration number
function DivineShield:SetInfo(bonusPercent, duration)
    self:SetDuration(duration)
    self.hp = self.initiator.attack:GetValue() * bonusPercent
end

--- @return void
--- for updating logic
function DivineShield:UpdateBeforeRound()
    self.isDecreaseDuration = false
end

--- @return void
--- for updating duration
function DivineShield:UpdateAfterRound()
    if self.isDecreaseDuration == false then
        self:DecreaseDuration()
        self.isDecreaseDuration = true
    end
end

--- @return number delta of damage
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function DivineShield:Calculate(enemyAttacker, totalDamage)
    if self.hp > totalDamage then
        self.hp = self.hp - totalDamage
        self:AddActionLog(enemyAttacker, totalDamage)
        return -totalDamage
    else
        local damage = self.hp
        self.hp = 0

        --- add log
        self:AddActionLog(enemyAttacker, damage)
        self:AddRemoveActionLog()

        --- remove shield
        self.myHero.effectController:ForceRemove(self)

        return -damage
    end
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param damage number
function DivineShield:AddActionLog(enemyAttacker, damage)
    local result = DivineShieldResult(enemyAttacker, self.myHero, self.duration, damage, self.hp)
    ActionLogUtils.AddLog(self.myHero.battle, result)
end

--- @return void
function DivineShield:AddRemoveActionLog()
    local result = DivineShieldResult(self.myHero, self.myHero, -1, 0, 0)
    ActionLogUtils.AddLog(self.myHero.battle, result)
end

---------------------------------------- Listeners ----------------------------------------
--- @return number delta of damage
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function DivineShield:OnShieldTakeDamage(initiator, reason, damage)
    if self:CanBlock(reason) == true then
        return self:Calculate(initiator, damage)
    end
    return 0
end

function DivineShield:CanBlock(reason)
    if reason == TakeDamageReason.ATTACK_DAMAGE or reason == TakeDamageReason.SKILL_DAMAGE
            or reason == TakeDamageReason.COUNTER_ATTACK_DAMAGE
            or reason == TakeDamageReason.SUB_ACTIVE_DAMAGE or reason == TakeDamageReason.MAIN_SUB_ACTIVE_DAMAGE
            or reason == TakeDamageReason.SPLASH_DAMAGE or reason == TakeDamageReason.BOUNCING_DAMAGE
            or reason == TakeDamageReason.BOND_DAMAGE then
        return true
    end

    return false
end

--- @return string
function DivineShield:ToDetailString()
    return string.format("%s, HP_REMAINING = %s", self:ToString(), self.hp)
end