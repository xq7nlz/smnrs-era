--- @class Hero60011_BattleHelper
Hero60011_BattleHelper = Class(Hero60011_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero60011_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type Hero60011_Skill2
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero60011_BattleHelper:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function Hero60011_BattleHelper:CalculateAttackResult(target)
    local multiplier = self.basicAttackMultiplier
    if self.skill_3 ~= nil then
        multiplier = self.skill_3:CalculateAttackResult(target, multiplier)
    end

    return self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, multiplier)
end