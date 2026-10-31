--- @class BattleHelper
BattleHelper = Class(BattleHelper)

--- @return void
--- @param hero BaseHero
function BattleHelper:Ctor(hero)
    --- @type BaseHero
    self.myHero = hero

    --- @type number
    self.basicAttackMultiplier = nil

    --- @type List<DamageItemOption>
    self.damageItemOptionList = List()

    --- @type List<BaseSkill>
    --- Talent 2000201, 2000501
    self.damageItemPassiveList = List()
end

--- @return void
--- @param multiplier number
function BattleHelper:SetBasicAttackMultiplier(multiplier)
    self.basicAttackMultiplier = multiplier
end

--- @return void
--- @param itemOption DamageItemOption
function BattleHelper:AddDamageItemOption(itemOption)
    self.damageItemOptionList:Add(itemOption)
end

--- @return void
--- @param itemPassive BaseSkill
function BattleHelper:AddDamageItemPassive(itemPassive)
    self.damageItemPassiveList:Add(itemPassive)
end

---------------------------------------- Damage formulas ----------------------------------------
--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param type DamageFormulaType
--- @param multiplier number
--- @param damageReason TakeDamageReason (only for dot effect)
function BattleHelper:_CalculateResult(target, type, multiplier, damageReason)
    local damage, isCrit, accuracy = self:CalculateDamage(target, type, multiplier, damageReason)
    local armorBreak = self.myHero.armorBreak:GetValue()

    local normalDamage = self.myHero.attack:CalculateDamage(damage, armorBreak, target.defense:GetValue())
    local pureDamage = self.myHero.pureDamage:CalculatePureDamage(target, self.myHero.attack:GetValue())

    local dodgeType, dodgeDamageRate = self:CalculateDodgeStat(target, type, isCrit, accuracy)
    local isBlock, blockDamageRate = self:CalculateBlock(target, type, dodgeType)

    local finalDamageReduction = target.damageReduction:GetValue() - self.myHero.reduceDamageReduction:GetValue()
    if finalDamageReduction < 0 then
        finalDamageReduction = 0
    end

    local totalDamage = MathUtils.Truncate(((normalDamage * blockDamageRate) * (1 - finalDamageReduction) + pureDamage) * dodgeDamageRate)

    --print(string.format("%s => %s, normalDamage = %s, blockDamageRate = %s, pureDamage = %s, damageReduction = %s, dodgeDamageRate = %s, type = %s",
    --        self.myHero:ToString(), target:ToString(), normalDamage, blockDamageRate, pureDamage, damageReduction, dodgeDamageRate, type))

    if type == DamageFormulaType.BASIC_ATTACK or type == DamageFormulaType.ACTIVE_SKILL then
        for i = 1, self.damageItemOptionList:Count() do
            ---@type DamageItemOption
            local itemOption = self.damageItemOptionList:Get(i)
            totalDamage = MathUtils.Truncate(itemOption:CalculateDamage(target, totalDamage))
        end
    end

    for i = 1, self.damageItemPassiveList:Count() do
        ---@type BaseSkill
        local passiveSkill = self.damageItemPassiveList:Get(i)
        totalDamage = MathUtils.Truncate(passiveSkill:CalculateDamage(totalDamage, type, damageReason, target))
    end

    return math.floor(totalDamage), isCrit, dodgeType, isBlock
end

--- @return number, boolean, number damage, isCrit, accuracy
--- @param target BaseHero
--- @param type DamageFormulaType
--- @param multiplier number
--- @param damageReason TakeDamageReason (only for dot effect)
function BattleHelper:CalculateDamage(target, type, multiplier, damageReason)
    local damage, isCrit, accuracy
    if type == DamageFormulaType.BASIC_ATTACK then
        multiplier = self:GetBasicAttackMultiplier(target, multiplier)
        damage = self.myHero.attack:GetValue() * self.myHero.attack:GetMultiAddByTarget(target, multiplier)

        accuracy = self.myHero.originInfo:CalculateAccuracyFactionBonus(target)
        isCrit, damage = self:CalculateCrit(target, damage, type)

        target.battle.statisticsController:AddDamageTakenThroughFormula(target, damage, TakeDamageReason.ATTACK_DAMAGE)

    elseif type == DamageFormulaType.ACTIVE_SKILL then
        multiplier = self:GetSkillMultiplier(target, multiplier)
        damage = self.myHero.attack:GetValue() * self.myHero.attack:GetMultiAddByTarget(target, multiplier)

        accuracy = self.myHero.accuracy:GetValue()
        isCrit, damage = self:CalculateCrit(target, damage, type)

        target.battle.statisticsController:AddDamageTakenThroughFormula(target, damage, TakeDamageReason.SKILL_DAMAGE)

    elseif type == DamageFormulaType.COUNTER_ATTACK then
        multiplier = self:GetCounterAttackMultiplier(target, multiplier)
        damage = self.myHero.attack:GetValue() * self.myHero.attack:GetMultiAddByTarget(target, multiplier)

        accuracy = self.myHero.accuracy:GetValue()
        isCrit = false

        target.battle.statisticsController:AddDamageTakenThroughFormula(target, damage, TakeDamageReason.COUNTER_ATTACK_DAMAGE)

    elseif type == DamageFormulaType.SUB_ACTIVE_SKILL then
        multiplier = self:GetSubSkillMultiplier(target, multiplier)
        damage = self.myHero.attack:GetValue() * self.myHero.attack:GetMultiAddByTarget(target, multiplier)

        accuracy = self.myHero.accuracy:GetValue()
        isCrit = false

        target.battle.statisticsController:AddDamageTakenThroughFormula(target, damage, TakeDamageReason.SUB_ACTIVE_DAMAGE)

    elseif type == DamageFormulaType.DOT_EFFECT then
        multiplier = self:GetDotEffectMultiplier(target, multiplier)
        damage = self.myHero.attack:GetValue() * self.myHero.attack:GetMultiAddByTarget(target, multiplier)

        accuracy = self.myHero.accuracy:GetValue()
        isCrit = false

        target.battle.statisticsController:AddDamageTakenThroughFormula(target, damage, damageReason)
    end

    return MathUtils.Truncate(damage), isCrit, accuracy
end

--- @return boolean, number
--- @param target BaseHero
--- @param baseDamage number
--- @param damageType DamageFormulaType
function BattleHelper:CalculateCrit(target, baseDamage, damageType)
    local critRate = self.myHero.critRate:GetValue()
    return self.myHero.critDamage:CalculateCritDamage(target, baseDamage, critRate)
end

--- @return DodgeType, number dodgeType, dodgeDamageRate
--- @param target BaseHero
--- @param type DamageFormulaType
--- @param isCrit boolean
--- @param accuracy DamageFormulaType
function BattleHelper:CalculateDodgeStat(target, type, isCrit, accuracy)
    local dodgeType, dodgeDamageRate
    if type == DamageFormulaType.BASIC_ATTACK then
        dodgeType, dodgeDamageRate = target.dodge:CalculateDodgeDamage(isCrit, accuracy)
    elseif type == DamageFormulaType.COUNTER_ATTACK then
        dodgeType, dodgeDamageRate = target.dodge:CalculateDodgeDamage(isCrit, accuracy)
    else
        dodgeType, dodgeDamageRate = DodgeType.NO_DODGE, 1
    end

    return dodgeType, dodgeDamageRate
end

--- @return boolean, number
--- @param target BaseHero
--- @param type DamageFormulaType
--- @param dodgeType DodgeType
function BattleHelper:CalculateBlock(target, type, dodgeType)
    if dodgeType ~= DodgeType.MISS and type ~= DamageFormulaType.DOT_EFFECT then
        local skillBlockDamageRate = 1 - target.skillController:GetBlockDamageRate(target, type)

        local effectBlockDamageRate
        if type == DamageFormulaType.ACTIVE_SKILL or type == DamageFormulaType.BASIC_ATTACK then
            effectBlockDamageRate = 1 - target.effectController:GetBlockDamageRate(target, type)
        else
            effectBlockDamageRate = 1
        end

        local blockDamageRate = MathUtils.Truncate(skillBlockDamageRate * effectBlockDamageRate)
        local isBlock
        if blockDamageRate < 1 then
            isBlock = true
        else
            isBlock = false
        end

        return isBlock, blockDamageRate
    else
        return false, 1
    end
end

---------------------------------------- Calculate multiplier ----------------------------------------
--- @return number
--- @param target BaseHero
--- @param multiplier number
function BattleHelper:GetBasicAttackMultiplier(target, multiplier)
    multiplier = self.myHero.originInfo:CalculateAttackFactionBonus(target, multiplier)
    return multiplier
end

--- @return number
--- @param target BaseHero
--- @param multiplier number
function BattleHelper:GetSkillMultiplier(target, multiplier)
    multiplier = MathUtils.Truncate(self.myHero.originInfo:CalculateAttackFactionBonus(target, multiplier))
    multiplier = MathUtils.Truncate(self.myHero.skillDamage:CalculateSkillDamage(target, multiplier))
    return multiplier
end

--- @return number
--- @param target BaseHero
--- @param multiplier number
function BattleHelper:GetCounterAttackMultiplier(target, multiplier)
    multiplier = self.myHero.originInfo:CalculateAttackFactionBonus(target, multiplier)
    return multiplier
end

--- @return number
--- @param target BaseHero
--- @param multiplier number
function BattleHelper:GetSubSkillMultiplier(target, multiplier)
    multiplier = MathUtils.Truncate(self.myHero.originInfo:CalculateAttackFactionBonus(target, multiplier))
    multiplier = MathUtils.Truncate(self.myHero.skillDamage:CalculateSkillDamage(target, multiplier))
    return multiplier
end

--- @return number
--- @param target BaseHero
--- @param multiplier number
function BattleHelper:GetDotEffectMultiplier(target, multiplier)
    multiplier = self.myHero.originInfo:CalculateAttackFactionBonus(target, multiplier)
    return multiplier
end

---------------------------------------- Public methods ----------------------------------------
--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function BattleHelper:CalculateAttackResult(target)
    return self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, self.basicAttackMultiplier)
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param damageMultiplier number
function BattleHelper:CalculateActiveSkillResult(target, damageMultiplier)
    return self:_CalculateResult(target, DamageFormulaType.ACTIVE_SKILL, damageMultiplier)
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param damageMultiplier number
function BattleHelper:CalculateCounterAttackResult(target, damageMultiplier)
    return self:_CalculateResult(target, DamageFormulaType.COUNTER_ATTACK, damageMultiplier)
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param damageMultiplier number
function BattleHelper:CalculateSubActiveResult(target, damageMultiplier)
    return self:_CalculateResult(target, DamageFormulaType.SUB_ACTIVE_SKILL, damageMultiplier)
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param damageMultiplier number
--- @param damageReason TakeDamageReason (only for dot effect)
function BattleHelper:CalculateDotEffectResult(target, damageMultiplier, damageReason)
    return self:_CalculateResult(target, DamageFormulaType.DOT_EFFECT, damageMultiplier, damageReason)
end