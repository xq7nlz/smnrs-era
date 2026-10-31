--- @class Hero30012_BattleHelper
Hero30012_BattleHelper = Class(Hero30012_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero30012_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type
    self.skill_3 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero30012_BattleHelper:BindingWithSkill_3(skill)
    self.skill_3 = skill
end


--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function Hero30012_BattleHelper:CalculateAttackResult(target)
    local multiBasicAtk = self.basicAttackMultiplier
    if self.skill_3 ~= nil then
        multiBasicAtk = self.skill_3:GetMultiDamage(target, multiBasicAtk)
    end
    return self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, multiBasicAtk)
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param skillMultiplier number
function Hero30012_BattleHelper:CalculateActiveSkillResult(target, skillMultiplier)
    local multiSkillAtk = skillMultiplier

    if self.skill_3 ~= nil then
        multiSkillAtk = self.skill_3:GetMultiDamage(target, multiSkillAtk)
    end
    return self:_CalculateResult(target, DamageFormulaType.ACTIVE_SKILL, multiSkillAtk)
end