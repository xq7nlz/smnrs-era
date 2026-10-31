--- @class EffectListenerHelper
EffectListenerHelper = Class(EffectListenerHelper)

--- @return void
--- @param effectController EffectController
function EffectListenerHelper:Ctor(effectController)
    --- @type EffectController
    self.effectController = effectController

    --- @type Dictionary<EffectListenerType, List<BaseEffect>>
    self.allListeners = Dictionary()
end

---------------------------------------- Register Listeners ----------------------------------------
--- @return void
--- @param listenerType EffectListenerType
--- @param effect BaseEffect
function EffectListenerHelper:Register(listenerType, effect)
    local listeners = self:GetOrCreateListeners(listenerType)
    listeners:Add(effect)
end

--- @return void
--- @param listenerType EffectListenerType
--- @param effect BaseEffect
function EffectListenerHelper:Unregister(listenerType, effect)
    local listeners = self:GetOrCreateListeners(listenerType)
    listeners:RemoveOneByReference(effect)
end

--- @return void
--- @param listenerType EffectListenerType
function EffectListenerHelper:GetOrCreateListeners(listenerType)
    local listeners = self.allListeners:Get(listenerType)
    if listeners == nil then
        listeners = List()
        self.allListeners:Add(listenerType, listeners)
    end

    return listeners
end

---------------------------------------- Listeners ----------------------------------------
--- @return number
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function EffectListenerHelper:OnTakeBasicAttackDamage(enemyAttacker, totalDamage)
    ---@type List<BaseEffect>
    local listeners = self:GetOrCreateListeners(EffectListenerType.TAKE_BASIC_ATTACK_DAMAGE)
    if listeners:Count() > 0 then
        local effectsToRemove = List()

        local delta = 0
        ---@param effect BaseEffect
        for _, effect in pairs(listeners:GetItems()) do
            delta = delta + effect:OnBeAttacked(enemyAttacker, totalDamage)
            if effect:IsShouldRemove() then
                listeners:RemoveOneByReference(effect)
                effectsToRemove:Add(effect)
            end
        end

        self.effectController:_RemoveEffects(effectsToRemove)
        totalDamage = math.max(totalDamage + delta, 0)
    end

    return totalDamage
end

--- @return number
--- @param enemy BaseHero
--- @param totalDamage number
function EffectListenerHelper:OnTakeSkillDamage(enemy, totalDamage)
    ---@type List<BaseEffect>
    local listeners = self:GetOrCreateListeners(EffectListenerType.TAKE_SKILL_DAMAGE)
    if listeners:Count() > 0 then
        local effectsToRemove = List()

        local delta = 0
        ---@param effect BaseEffect
        for _, effect in pairs(listeners:GetItems()) do
            delta = delta + effect:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
            if effect:IsShouldRemove() then
                listeners:RemoveOneByReference(effect)
                effectsToRemove:Add(effect)
            end
        end

        self.effectController:_RemoveEffects(effectsToRemove)
        totalDamage = math.max(totalDamage + delta, 0)
    end

    return totalDamage
end

--- @return number
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function EffectListenerHelper:OnTakeDamage(initiator, reason, damage)
    damage = self:OnShieldTakeDamage(initiator, reason, damage, EffectType.DIVINE_SHIELD)
    damage = self:OnShieldTakeDamage(initiator, reason, damage, EffectType.REVERSE_SHIELD)
    damage = self:OnShieldTakeDamage(initiator, reason, damage, EffectType.LIGHT_SHIELD)
    ---@type List<BaseEffect>
    local listeners = self:GetOrCreateListeners(EffectListenerType.TAKE_DAMAGE)
    if listeners:Count() > 0 then
        local delta = 0
        ---@param effect BaseEffect
        for _, effect in pairs(listeners:GetItems()) do
            delta = delta + effect:OnTakeDamage(initiator, reason, damage)
        end

        damage = math.max(damage + delta, 0)
    end

    return damage
end

--- @return number
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function EffectListenerHelper:OnShieldTakeDamage(initiator, reason, damage, effectType)
    local shields = self.effectController:GetEffectWithType(effectType)
    if shields:Count() > 0 then
        local shield = shields:Get(1)
        local delta = shield:OnShieldTakeDamage(initiator, reason, damage)
        damage = math.max(damage + delta, 0)
    end
    return damage
end

--- @return number
--- @param initiator BaseHero
--- @param reason HealReason
--- @param healAmount number
function EffectListenerHelper:OnHeal(initiator, reason, healAmount)
    if self.effectController:IsContainEffectType(EffectType.PETRIFY) then
        healAmount = healAmount * (1 - EffectConstants.PETRIFY_HEAL_REDUCTION)
    end
    ---@type List<BaseEffect>
    local listeners = self:GetOrCreateListeners(EffectListenerType.HEAL)
    if listeners:Count() > 0 then
        local delta = 0
        ---@param effect BaseEffect
        for _, effect in pairs(listeners:GetItems()) do
            delta = delta + effect:OnHeal(initiator, reason, healAmount)
        end

        healAmount = math.max(healAmount + delta, 0)
    end

    return healAmount
end

--- @return void
--- @param initiator BaseHero
--- @param targetList List<BaseHero>
function EffectListenerHelper:OnSelectTargetForBasicAttack(initiator, targetList)
    ---@type List<BaseEffect>
    local listeners = self:GetOrCreateListeners(EffectListenerType.SELECT_TARGET_FOR_BASIC_ATTACK)
    if listeners:Count() > 0 then
        ---@param effect BaseEffect
        for _, effect in pairs(listeners:GetItems()) do
            effect:OnSelectTargetForBasicAttack(initiator, targetList)
        end
    end
end

--- @return number delta of damage
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function EffectListenerHelper:OnLastChance(initiator, reason, damage)
    ---@type List<BaseEffect>
    local listeners = self:GetOrCreateListeners(EffectListenerType.LAST_CHANCE)
    if listeners:Count() > 0 then
        ---@param effect BaseEffect
        for _, effect in pairs(listeners:GetItems()) do
            damage = effect:OnLastChance(initiator, reason, damage)
        end
    end

    return damage
end

--- @return number
--- @param ccEffect BaseEffect
function EffectListenerHelper:OnTakeCCEffect(ccEffect)
    ---@type List<BaseEffect>
    local listeners = self:GetOrCreateListeners(EffectListenerType.TAKE_CC)
    if listeners:Count() > 0 then
        ---@param effect BaseEffect
        for _, effect in pairs(listeners:GetItems()) do
            effect:OnTakeCCEffect(ccEffect)
        end
    end
end