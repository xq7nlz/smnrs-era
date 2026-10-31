--- @class Hero20005_BattleHelper Cennunos
Hero20005_BattleHelper = Class(Hero20005_BattleHelper, BattleHelper)

function Hero20005_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type number
    self.multiplierDamagePerEffect = 0

    --- @type EffectType
    self.effect_check = 0
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function Hero20005_BattleHelper:CalculateAttackResult(target)
    local effects = target.effectController:GetEffectWithType(self.effect_check)
    local multiplier = self.basicAttackMultiplier
    if effects ~= nil and effects:Count() > 0 then
        multiplier = multiplier * (1 + self.multiplierDamagePerEffect * effects:Count())
    end

    return self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, multiplier)
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param skillMultiplier number
function Hero20005_BattleHelper:CalculateActiveSkillResult(target, skillMultiplier)
    local effects = target.effectController:GetEffectWithType(self.effect_check)
    local multiplier = skillMultiplier
    if effects ~= nil and effects:Count() > 0 then
        multiplier = multiplier * (1 + self.multiplierDamagePerEffect * effects:Count())
    end

    return self:_CalculateResult(target, DamageFormulaType.ACTIVE_SKILL, multiplier)
end

--- @return void
--- @param multiplier number
function Hero20005_BattleHelper:SetMultiplierDamagePerDotEffect(multiplier, effect_check)
    self.multiplierDamagePerEffect = multiplier
    self.effect_check = effect_check
end