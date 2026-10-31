--- @class Hero50025_Skill3 Avorn
Hero50025_Skill3 = Class(Hero50025_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50025_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.bonusAttackDamageMultiplier = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @param hero BaseHero
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50025_Skill3:CreateInstance(id, hero)
    return Hero50025_Skill3(id, hero)
end

--- @return void
function Hero50025_Skill3:Init()
    self.bonusAttackChance = self.data.bonusAttackChance
    self.bonusAttackDamageMultiplier = self.data.bonusAttackDamageMultiplier

    self.myHero.attackController:BindingWithSkill(self)
end

--- @return void
function Hero50025_Skill3:GetNumberAttack()
    if self.myHero.randomHelper:RandomRate(self.bonusAttackChance) then
        return 2
    else
        return 1
    end
end

--- @return void
--- @param attackNumber number
function Hero50025_Skill3:GetAttackDamageMultiplier(attackNumber)
    if attackNumber > 1 then
        return self.bonusAttackDamageMultiplier
    end

    return 1
end

return Hero50025_Skill3