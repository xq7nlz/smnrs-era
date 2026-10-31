--- @class Hero20011_BattleHelper
Hero20011_BattleHelper = Class(Hero20011_BattleHelper, BattleHelper)

function Hero20011_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)
    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero20011_BattleHelper:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function Hero20011_BattleHelper:CalculateAttackResult(target)
    local multiBasicAtk = self.basicAttackMultiplier
    if self.skill_2 ~= nil then
        multiBasicAtk = self.skill_2:GetDamage(target, multiBasicAtk)
    end
    return self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, multiBasicAtk)
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param skillMultiplier number
function Hero20011_BattleHelper:CalculateActiveSkillResult(target, skillMultiplier)
    local multiSkillAtk = skillMultiplier

    if self.skill_2 ~= nil then
        multiSkillAtk = self.skill_2:GetDamage(target, multiSkillAtk)
    end
    return self:_CalculateResult(target, DamageFormulaType.ACTIVE_SKILL, multiSkillAtk)
end