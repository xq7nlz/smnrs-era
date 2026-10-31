--- @class Hero60005_BattleHelper
Hero60005_BattleHelper = Class(Hero60005_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero60005_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type BaseSkill
    self.skillActive = nil
end

--- @return void
--- @param skill BaseSkill
function Hero60005_BattleHelper:BindingWithSkillActive(skill)
    self.skillActive = skill
end

---------------------------------------- Calculate ----------------------------------------
--- @return boolean, number
--- @param target BaseHero
--- @param baseDamage number
--- @param damageType DamageFormulaType
function Hero60005_BattleHelper:CalculateCrit(target, baseDamage, damageType)
    if damageType == DamageFormulaType.ACTIVE_SKILL then
        local critRate = self.myHero.critRate:GetValue()
        if self.skillActive ~= nil then
            critRate = self.skillActive:GetCritRateByTarget(target, critRate)
        end
        return self.myHero.critDamage:CalculateCritDamage(target, baseDamage, critRate)
    else
        return BattleHelper.CalculateCrit(self, target, baseDamage, damageType)
    end
end
