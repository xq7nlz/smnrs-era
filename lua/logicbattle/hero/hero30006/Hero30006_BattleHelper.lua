--- @class Hero30006_BattleHelper
Hero30006_BattleHelper = Class(Hero30006_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero30006_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30006_BattleHelper:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number, boolean, number damage, isCrit, accuracy
--- @param target BaseHero
--- @param type DamageFormulaType
--- @param multiplier number
function Hero30006_BattleHelper:CalculateDamage(target, type, multiplier)
    local damage, isCrit, accuracy = BattleHelper.CalculateDamage(self, target, type, multiplier)
    if self.skill_2 ~= nil then
        damage = damage * self.skill_2:GetBonus(target)
    end

    return damage, isCrit, accuracy
end