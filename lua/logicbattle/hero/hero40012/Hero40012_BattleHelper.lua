--- @class Hero40012_BattleHelper
Hero40012_BattleHelper = Class(Hero40012_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero40012_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40012_BattleHelper:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function Hero40012_BattleHelper:CalculateAttackResult(target)
    local multiplier = self.basicAttackMultiplier
    if self.skill_4 ~= nil then
        multiplier = self.skill_4:GetBonusMultiDamageAdd(target , multiplier)
    end

    return self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, multiplier)
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param skillMultiplier number
function Hero40012_BattleHelper:CalculateActiveSkillResult(target, skillMultiplier)
    local multiSkillAtk = skillMultiplier

    if self.skill_4 ~= nil then
        multiSkillAtk = self.skill_4:GetBonusMultiDamageAdd(target, multiSkillAtk)
    end
    return self:_CalculateResult(target, DamageFormulaType.ACTIVE_SKILL, multiSkillAtk)
end