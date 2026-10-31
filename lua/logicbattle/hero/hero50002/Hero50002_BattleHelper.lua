--- @class Hero50002_BattleHelper
Hero50002_BattleHelper = Class(Hero50002_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero50002_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50002_BattleHelper:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function Hero50002_BattleHelper:CalculateAttackResult(target)
    local multiplier = self.basicAttackMultiplier
    if self.skill_2 ~= nil then
        multiplier = multiplier * (1 + self.skill_2:CalculateAttackResult(target))
    end

    return self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, multiplier)
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param damageMultiplier number
function Hero50002_BattleHelper:CalculateActiveSkillResult(target, damageMultiplier)
    local multiplier = damageMultiplier
    if self.skill_2 ~= nil then
        multiplier = multiplier * (1 + self.skill_2:CalculateAttackResult(target))
    end

    return self:_CalculateResult(target, DamageFormulaType.ACTIVE_SKILL, multiplier)
end