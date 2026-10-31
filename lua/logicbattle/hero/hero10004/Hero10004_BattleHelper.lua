--- @class Hero10004_BattleHelper
Hero10004_BattleHelper = Class(Hero10004_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero10004_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero10004_BattleHelper:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function Hero10004_BattleHelper:CalculateAttackResult(target)
    local multiplier = self.basicAttackMultiplier
    if self.skill_3 ~= nil then
        multiplier = multiplier * (1 + self.skill_3:CalculateAttackResult(target))
    end

    return self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, multiplier)
end