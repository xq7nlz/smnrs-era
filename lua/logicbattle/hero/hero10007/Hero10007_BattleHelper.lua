--- @class Hero10007_BattleHelper : BattleHelper
Hero10007_BattleHelper = Class(Hero10007_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero10007_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero10007_BattleHelper:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function Hero10007_BattleHelper:CalculateAttackResult(target)
    local multiplier = self.basicAttackMultiplier
    if self.skill_2 ~= nil then
        multiplier = self.skill_2:CalculateAttackResult(target)
    end

    return self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, multiplier)
end