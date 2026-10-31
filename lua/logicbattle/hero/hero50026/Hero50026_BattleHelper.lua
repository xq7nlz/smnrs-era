--- @class Hero50026_BattleHelper
Hero50026_BattleHelper = Class(Hero50026_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero50026_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50026_BattleHelper:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function Hero50026_BattleHelper:CalculateAttackResult(target)
    local multiplier = self.basicAttackMultiplier
    if self.skill_3 ~= nil then
        multiplier = self.skill_3:GetDamageBonus(target, multiplier)
    end

    return self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, multiplier)
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param damageMultiplier number
function Hero50026_BattleHelper:CalculateActiveSkillResult(target, damageMultiplier)
    local multiplier = damageMultiplier
    if self.skill_3 ~= nil then
        multiplier = self.skill_3:GetDamageBonus(target, multiplier)
    end

    return self:_CalculateResult(target, DamageFormulaType.ACTIVE_SKILL, multiplier)
end
