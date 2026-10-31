--- @class Hero40027_BattleHelper : BattleHelper
Hero40027_BattleHelper = Class(Hero40027_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero40027_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type Hero40027_Skill2
    self.skill_2 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero40027_BattleHelper:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

---------------------------------------- Calculate ----------------------------------------
--- @return boolean, number
--- @param target BaseHero
--- @param baseDamage number
--- @param damageType DamageFormulaType
function Hero40027_BattleHelper:CalculateCrit(target, baseDamage, damageType)
    if self.skill_2 == nil then
        return BattleHelper.CalculateCrit(self, target, baseDamage, damageType)
    end

    if damageType == DamageFormulaType.BASIC_ATTACK and self.myHero.isDragonForm == true then
        local critRate = self.skill_2:GetCritRateByTarget()
        return self.myHero.critDamage:CalculateCritDamage(target, baseDamage, critRate)
    else
        return BattleHelper.CalculateCrit(self, target, baseDamage, damageType)
    end
end

