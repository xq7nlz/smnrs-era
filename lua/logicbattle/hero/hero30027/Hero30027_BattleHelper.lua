--- @class Hero30027_BattleHelper
Hero30027_BattleHelper = Class(Hero30027_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero30027_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30027_BattleHelper:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return boolean, number
--- @param target BaseHero
--- @param baseDamage number
--- @param damageType DamageFormulaType
function Hero30027_BattleHelper:CalculateCrit(target, baseDamage, damageType)
    return self.myHero.critDamage:CalculateCritDamage(target, baseDamage, 0)
end


