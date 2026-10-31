--- @class Hero60025_Skill2 Vampire
Hero60025_Skill2 = Class(Hero60025_Skill2, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @param hero BaseHero
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60025_Skill2:CreateInstance(id, hero)
    return Hero60025_Skill2(id, hero)
end

--- @return void
function Hero60025_Skill2:Init()
    local activeSkill = self.myHero.skillController.activeSkill
    activeSkill:BindingWithSkill_2(self)
end

--- @return number
function Hero60025_Skill2:GetHealBonus()
    return self.data.healBonus
end

return Hero60025_Skill2