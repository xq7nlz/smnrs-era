--- @class Hero50012_BattleHelper
Hero50012_BattleHelper = Class(Hero50012_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero50012_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50012_BattleHelper:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function Hero50012_BattleHelper:CalculateAttackResult(target)
    local multi = self.basicAttackMultiplier
    if self.skill_4 ~= nil then
        multi = self.skill_4:GetDamageBonusBasicAttack(target, multi)
    end
    return self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, multi)
end
