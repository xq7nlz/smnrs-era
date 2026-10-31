--- @class EffectController
EffectController = Class(EffectController)

--- @return void
--- @param hero BaseHero
function EffectController:Ctor(hero)
    --- @type BaseHero
    self.myHero = hero

    --- @type List<BaseEffect>
    self.permanentEffectList = List()

    --- @type DirtyList -- <BaseEffect>
    self.effectList = DirtyList()

    --- @type EffectListenerHelper
    self.effectListener = EffectListenerHelper(self)
    --- @type EffectUpdaterHelper
    self.effectUpdater = EffectUpdaterHelper(self)
end

---------------------------------------- Manage effects ----------------------------------------
--- @return boolean
--- @param effect BaseEffect
--- @param isCanShare boolean
function EffectController:AddEffect(effect, isCanShare)
    if self.myHero:IsDead() then
        return false
    end

    if self:CanAdd(effect) == false then
        ActionLogUtils.CreateResistEffectResult(effect.initiator, self.myHero, effect.type)
        return false
    end

    ActionLogUtils.CreateEffectChangeResult(self.myHero, effect, EffectChangeType.ADD)
    effect:OnEffectAdd(self.myHero)

    if effect:GetPersistentType() == EffectPersistentType.PERMANENT
        or effect:GetPersistentType() == EffectPersistentType.PERMANENT_REMOVABLE then
        self.permanentEffectList:Add(effect)
    else
        self.effectList:Add(effect)
        self.myHero.battle.statisticsController:OnEffectAdd(effect)

        if effect:IsCCEffect() then
            self.effectListener:OnTakeCCEffect(effect)
        end

        if isCanShare == nil or isCanShare == true then
            self.myHero.battle.bondManager:OnTakeEffect(effect)
        end
    end

    return true
end

--- @return void
--- @param effectList List<BaseEffect>
function EffectController:AddMultipleEffects(effectList)
    local i = 1
    while i <= effectList:Count() do
        ---@type BaseEffect
        local effect = effectList:Get(i)
        self:AddEffect(effect)
        i = i + 1
    end
end

--- @return void
--- @param auraEffects List<BaseEffect>
function EffectController:RemoveAuraEffects(auraEffects)
    local i = 1
    while i <= auraEffects:Count() do
        local effect = auraEffects:Get(i)
        if effect:GetPersistentType() == EffectPersistentType.DEPEND_ON_AURA then
            effect:OnEffectRemove(self.myHero)
            ActionLogUtils.CreateEffectChangeResult(self.myHero, effect, EffectChangeType.REMOVE)

            self.effectList:RemoveOneByReference(effect)
        end
        i = i + 1
    end
end

--- @return void
--- @param effect BaseEffect
--- remove effect no matter what
function EffectController:ForceRemove(effect)
    if self:IsContainEffect(effect) == true then
        effect:OnEffectRemove(self.myHero)
        ActionLogUtils.CreateEffectChangeResult(self.myHero, effect, EffectChangeType.REMOVE)

        if effect.persistentType == EffectPersistentType.PERMANENT_REMOVABLE then
            self.permanentEffectList:RemoveOneByReference(effect)
        else
            self.effectList:RemoveOneByReference(effect)
        end
    end
end

--- @return void dispel all buffs
--- only remove non-persistent buffs
function EffectController:DispelBuff()
    local effectsToRemove = List()
    local i = 1
    while i <= self.effectList:Count() do
        ---@type BaseEffect
        local effect = self.effectList:Get(i)
        if effect.isBuff == true then
            if effect:IsRemovableType() then
                effectsToRemove:Add(effect)
            end
        end
        i = i + 1
    end
    self:_RemoveEffects(effectsToRemove)
end

--- @return void dispel all buffs
--- only remove non-persistent debuff
function EffectController:DispelDebuff()
    local effectsToRemove = List()
    local i = 1
    while i <= self.effectList:Count() do
        ---@type BaseEffect
        local effect = self.effectList:Get(i)
        if effect.isBuff == false then
            if effect:IsRemovableType() then
                effectsToRemove:Add(effect)
            end
        end
        i = i + 1
    end
    self:_RemoveEffects(effectsToRemove)
end

--- @return void
--- @param effectList List<BaseEffect>
function EffectController:_RemoveEffects(effectList)
    local i = 1
    while i <= effectList:Count() do
        ---@type BaseEffect
        local effect = effectList:Get(i)
        effect:OnEffectRemove(self.myHero)
        ActionLogUtils.CreateEffectChangeResult(self.myHero, effect, EffectChangeType.REMOVE)

        self.effectList:RemoveOneByReference(effect)
        i = i + 1
    end
end

---------------------------------------- Update effects ----------------------------------------
--- @return void
--- call at start of each round
function EffectController:UpdateBeforeRound()
    self.effectUpdater:UpdateBeforeRound()
end

--- @return void
--- call at end of each round
function EffectController:UpdateAfterRound()
    self.effectUpdater:UpdateAfterRound()
end

---------------------------------------- Getters ----------------------------------------
--- @return boolean
--- @param effect BaseEffect
function EffectController:CanAdd(effect)
    if effect:IsNonPersistent() then
        if effect.isBuff == false then
            --- Won't receive debuff if blessed
            if self:IsTriggerMarkEffect(EffectType.BLESS_MARK, effect.type) then
                return false
            end

            if self:IsTriggerMarkEffect(EffectType.RESIST_SILENCE, effect.type) then
                return false
            end

            if self:IsTriggerMarkEffect(EffectType.TALENT_BLOCK_SILENT_CAST, effect.type) then
                return false
            end

            if effect:IsCCEffect() then
                local isResistCC = self.myHero.randomHelper:RandomRate(self.myHero.ccResistance:GetValue())
                if isResistCC then
                    return false
                end
            end
        else
            --- Won't receive buff if cursed
            if self:IsTriggerMarkEffect(EffectType.CURSE_MARK, effect.type) then
                return false
            end
        end
    else
        if effect.isBuff == false then
            if effect:IsCCEffect() then
                local isResistCC = self.myHero.randomHelper:RandomRate(self.myHero.ccResistance:GetValue())
                if isResistCC then
                    return false
                end
            end
        end
    end

    return true
end

--- @return boolean
--- @param effectMarkToCheck EffectType
--- @param effectType EffectType
function EffectController:IsTriggerMarkEffect(effectMarkToCheck, effectType)
    local i = 1
    while i <= self.effectList:Count() do
        ---@type BaseEffect
        local effect = self.effectList:Get(i)
        if effect.type == effectMarkToCheck then
            return effect:IsTrigger(effectType)
        end
        i = i + 1
    end
    return false
end

--- @return boolean
--- @param effectType EffectType
function EffectController:IsContainEffectType(effectType)
    local i = 1
    while i <= self.effectList:Count() do
        ---@type BaseEffect
        local effect = self.effectList:Get(i)
        if effect.type == effectType then
            return true
        end
        i = i + 1
    end
    return false
end

--- @return boolean
--- @param effectToCheck BaseEffect
function EffectController:IsContainEffect(effectToCheck)
    local isContain = self.effectList:IsContainValue(effectToCheck)
    if isContain then
        return true
    end

    if effectToCheck.persistentType ~= EffectPersistentType.PERMANENT_REMOVABLE then
        return false
    end

    return self.permanentEffectList:IsContainValue(effectToCheck)
end

--- @return boolean
function EffectController:IsContainCCEffect()
    local i = 1
    while i <= self.effectList:Count() do
        ---@type BaseEffect
        local effect = self.effectList:Get(i)
        if effect:IsCCEffect() then
            return true
        end
        i = i + 1
    end
    return false
end

--- @return boolean
function EffectController:IsSilenced()
    if self:IsContainEffectType(EffectType.SILENCE) then
        return true
    end
    return false
end

--- @return boolean
function EffectController:CanHeal()
    if self:IsContainEffectType(EffectType.RESIST_HEAL) then
        return false
    end
    return true
end

--- @return boolean
function EffectController:IsContainRemovableDeBuffEffect()
    local i = 1
    while i <= self.effectList:Count() do
        local effect = self.effectList:Get(i)
        if effect.isBuff == false then
            if effect:GetPersistentType() == EffectPersistentType.NON_PERSISTENT or
                    effect:GetPersistentType() == EffectPersistentType.LOST_WHEN_REVIVE then
                return true
            end
        end
        i = i + 1
    end

    return false
end

--- @return List<BaseEffect>
--- @param effectType EffectType
function EffectController:GetEffectWithType(effectType)
    local results = List()
    local i = 1
    while i <= self.effectList:Count() do
        ---@type BaseEffect
        local effect = self.effectList:Get(i)
        if effect.type == effectType then
            results:Add(effect)
        end
        i = i + 1
    end
    return results
end

--- @return BaseEffect
--- @param effectType EffectType
function EffectController:GetDistinctEffectWithType(effectType)
    local i = 1
    while i <= self.effectList:Count() do
        ---@type BaseEffect
        local effect = self.effectList:Get(i)
        if effect.type == effectType then
            return effect
        end
        i = i + 1
    end

    return nil
end

--- @return number
--- @param target BaseHero
--- @param numberExtraTurn number
--- @param damage number
function EffectController:GetBonusDamageExtraTurn(target, numberExtraTurn, damage)
    if numberExtraTurn > 0 then
        local effects = self:GetEffectWithType(EffectType.BONUS_DAMAGE_EXTRA_TURN)
        if effects:Count() > 0 then
            --- don't stack bonus damage of same effect
            ---@type BonusDamageExtraTurn
            local effect = effects:Get(1)
            damage = effect:OnExtraTurn(target, damage, numberExtraTurn)
        end

        effects = self:GetEffectWithType(EffectType.BONUS_DAMAGE_EXTRA_TURN_AND_CC)
        if effects:Count() > 0 then
            --- don't stack bonus damage of same effect
            ---@type BonusDamageExtraTurnAndCC
            local effect = effects:Get(1)
            damage = effect:OnExtraTurn(target, damage, numberExtraTurn)
        end
    end
    return damage
end

--- @return number
--- @param target BaseHero
--- @param multiplier number
function EffectController:GetBonusAttackMultiplier(target, multiplier)
    local effects = self:GetEffectWithType(EffectType.BONUS_ATTACK_BY_CLASS)
    if effects:Count() > 0 then
        --- don't stack bonus attack
        ---@type BaseEffect
        local effect = effects:Get(1)
        multiplier = multiplier * (1 + effect:GetBonusMultiplier(target))
    end
    return multiplier
end

--- @return number
--- @param target BaseHero
--- @param type DamageFormulaType
function EffectController:GetBlockDamageRate(target, type)
    local resultBlockRate = 0
    local magicShields = self:GetEffectWithType(EffectType.MAGIC_SHIELD)
    local i = 1
    while i <= magicShields:Count() do
        ---@type  MagicShield
        local magicShield = magicShields:Get(i)
        resultBlockRate = resultBlockRate + (1 - resultBlockRate) * magicShield:GetBlockDamageRate()
        i = i + 1
    end

    return resultBlockRate
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
function EffectController:OnDead()
    if self.effectList:Count() > 0 then
        local effectsToRemove = List()
        ---@param effect BaseEffect
        for _, effect in pairs(self.effectList:GetItems()) do
            if effect:IsLostWhenDead() then
                effectsToRemove:Add(effect)
            end
        end
        self:_RemoveEffects(effectsToRemove)
    end
end

--- @return void
function EffectController:OnRevive()
    if self.effectList:Count() > 0 then
        local effectsToRemove = List()
        ---@param effect BaseEffect
        for _, effect in pairs(self.effectList:GetItems()) do
            if effect:IsLostWhenRevive() then
                effectsToRemove:Add(effect)
            end
        end
        self:_RemoveEffects(effectsToRemove)
    end
end