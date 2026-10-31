--- @class Hero50011_BattleHelper
Hero50011_BattleHelper = Class(Hero50011_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero50011_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50011_BattleHelper:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function Hero50011_BattleHelper:CalculateAttackResult(target)
    local multiplier = self.basicAttackMultiplier
    if self.skill_3 ~= nil then
        multiplier = self.skill_3:GetDamageBonusBasicAttack(target, multiplier)
    end
    return self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, multiplier)
end
