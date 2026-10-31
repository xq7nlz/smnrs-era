--- @class BaseEffect
BaseEffect = Class(BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param effectType EffectType
--- @param isBuff boolean
function BaseEffect:Ctor(initiator, target, effectType, isBuff)
    --- @type BaseHero
    self.initiator = initiator

    --- @type BaseSkill
    self.initiatorSkill = nil

    ---@type BaseEffect
    self.creator = nil

    --- @type BaseHero
    self.myHero = target

    --- @type EffectType
    self.type = effectType

    --- @type boolean
    self.isBuff = isBuff

    --- @type EffectPersistentType
    self.persistentType = EffectPersistentType.NON_PERSISTENT

    --- @type number remaining turn
    self.duration = 0

    --- @type boolean
    self.isShouldRemove = false
end

---------------------------------------- Update ----------------------------------------
--- @return void
--- for updating logic
function BaseEffect:UpdateBeforeRound()
    --- override if needed
end

--- @return void
--- for updating duration
function BaseEffect:UpdateAfterRound()
    if self:IsNonPersistent() or self:IsEffectSpecialUpdatable() then
        self:DecreaseDuration()
    end
end

--- @return boolean this effect is expired or not
function BaseEffect:DecreaseDuration()
    if self.duration > 0 then
        self.duration = self.duration - 1
        if self.duration <= 0 then
            self.isShouldRemove = true
        end
    else
        self.isShouldRemove = true
    end
end

---------------------------------------- Setters ----------------------------------------

------ @return void
--- @param creator BaseEffect
function BaseEffect:SetCreator(creator)
    self.creator = creator
end

------ @return void
--- @param initiatorSkill BaseSkill
function BaseEffect:SetInitiatorSkill(initiatorSkill)
    self.initiatorSkill = initiatorSkill
end

------ @return void
--- @param duration number remaining turn
function BaseEffect:SetDuration(duration)
    self.duration = duration
end

--- @return void
--- @param persistentType EffectPersistentType
function BaseEffect:SetPersistentType(persistentType)
    self.persistentType = persistentType
end

--- @return void
--- Recalculate stat of BaseEffect
function BaseEffect:Recalculate()
    --- override if needed
end

---------------------------------------- Getters ----------------------------------------
--- @return boolean
function BaseEffect:IsRemovableType()
    return self.persistentType  == EffectPersistentType.NON_PERSISTENT or self.persistentType == EffectPersistentType.LOST_WHEN_REVIVE
end

--- @return boolean
function BaseEffect:IsCCEffect()
    if self.type == EffectType.STUN or self.type == EffectType.FREEZE or
            self.type == EffectType.SLEEP or self.type == EffectType.PETRIFY then
        return true
    end
    return false
end

--- @return boolean
function BaseEffect:IsDotEffect()
    if self.type == EffectType.BLEED or self.type == EffectType.BURN or self.type == EffectType.POISON then
        return true
    end
    return false
end

--- @return boolean
function BaseEffect:IsHealEffect()
    if self.type == EffectType.HEAL then
        return true
    end
    return false
end

--- @return EffectPersistentType
function BaseEffect:GetPersistentType()
    return self.persistentType
end

--- @return boolean this effect is expired or not
function BaseEffect:IsNonPersistent()
    if self.persistentType == EffectPersistentType.NON_PERSISTENT or
            self.persistentType == EffectPersistentType.NON_PERSISTENT_NOT_DISPELLABLE or
            self.persistentType == EffectPersistentType.LOST_WHEN_REVIVE then
        return true
    end
    return false
end

--- @return boolean this effect is expired or not
function BaseEffect:IsEffectSpecialUpdatable()
    return self.persistentType == EffectPersistentType.EFFECT_SPECIAL_UPDATABLE
end

--- @return boolean
function BaseEffect:IsLostWhenDead()
    if self.persistentType == EffectPersistentType.NON_PERSISTENT or
            self.persistentType == EffectPersistentType.NON_PERSISTENT_NOT_DISPELLABLE or
            self.persistentType == EffectPersistentType.LOST_WHEN_DEAD or
            self.persistentType == EffectPersistentType.EFFECT_SPECIAL or
            self.persistentType == EffectPersistentType.EFFECT_SPECIAL_UPDATABLE then
        return true
    end
    return false
end

--- @return boolean
function BaseEffect:IsLostWhenRevive()
    if self.persistentType == EffectPersistentType.NON_PERSISTENT or
            self.persistentType == EffectPersistentType.NON_PERSISTENT_NOT_DISPELLABLE or
            self.persistentType == EffectPersistentType.LOST_WHEN_REVIVE or
            self.persistentType == EffectPersistentType.EFFECT_SPECIAL or
            self.persistentType == EffectPersistentType.EFFECT_SPECIAL_UPDATABLE then
        return true
    end
    return false
end

--- @return boolean
function BaseEffect:IsShouldRemove()
    return self.isShouldRemove
end

---------------------------------------- Always call Listeners ----------------------------------------
--- @return void
--- @param target BaseHero
--- call right before remove effect to hero
function BaseEffect:OnEffectAdd(target)
    --- override if needed
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function BaseEffect:OnEffectRemove(target)
    --- override if needed
end

---------------------------------------- Conditional-based Listeners ----------------------------------------
--- These listeners only be called if added to listeners of effect controller

--- @return number delta of damage
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function BaseEffect:OnBeAttacked(enemyAttacker, totalDamage)
    --- override if needed
    return 0
end

--- @return number delta of damage
--- @param enemy BaseHero
--- @param totalDamage number
function BaseEffect:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    --- override if needed
    return 0
end

--- @return number delta of damage
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function BaseEffect:OnTakeDamage(initiator, reason, damage)
    --- override if needed
    return 0
end

--- @return number delta of damage
--- @param initiator BaseHero
--- @param reason HealReason
--- @param healAmount number
function BaseEffect:OnHeal(initiator, reason, healAmount)
    --- override if needed
    return 0
end

--- @return void
--- @param initiator BaseHero
--- @param selectedTargets List<BaseHero>
function BaseEffect:OnSelectTargetForBasicAttack(initiator, selectedTargets)
    --- override if needed
end

--- @return number
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function BaseEffect:OnLastChance(initiator, reason, damage)
    --- override if needed
    return 0
end

--- @return void
--- @param effect BaseEffect
function BaseEffect:OnTakeCCEffect(effect)
    --- override if needed
end

---------------------------------------- ToString ----------------------------------------
--- @return string
function BaseEffect:ToString()
    return string.format("id = %s, type = %s, initiator = %s, isBuff = %s, duration = %s, persistentType = %s",
            tostring(self), self.type, self.initiator:ToString(), tostring(self.isBuff), self.duration, self.persistentType)
    --return string.format("type = %s, initiator = %s, isBuff = %s, duration = %s, persistentType = %s",
    --        self.type, self.initiator:ToString(), tostring(self.isBuff), self.duration, self.persistentType)
end

--- @return string
function BaseEffect:ToDetailString()
    --- override if needed
    return self:ToString()
end