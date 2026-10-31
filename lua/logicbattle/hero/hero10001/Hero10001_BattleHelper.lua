--- @class Hero10001_BattleHelper
Hero10001_BattleHelper = Class(Hero10001_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero10001_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero10001_BattleHelper:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function Hero10001_BattleHelper:CalculateAttackResult(target)
    local multiplier = self.basicAttackMultiplier
    if self.skill_2 ~= nil then
        multiplier = self.skill_2:GetMultiplierDamage(target, multiplier)
    end

    return self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, multiplier)
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param damageMultiplier number
function Hero10001_BattleHelper:CalculateActiveSkillResult(target, damageMultiplier)
    local multiplier = damageMultiplier
    if self.skill_2 ~= nil then
        multiplier = self.skill_2:GetMultiplierDamage(target, multiplier)
    end

    return self:_CalculateResult(target, DamageFormulaType.ACTIVE_SKILL, multiplier)
end