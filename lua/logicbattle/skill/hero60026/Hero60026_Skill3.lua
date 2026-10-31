--- @class Hero60026_Skill3 Vampire
Hero60026_Skill3 = Class(Hero60026_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @param hero BaseHero
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60026_Skill3:CreateInstance(id, hero)
    return Hero60026_Skill3(id, hero)
end

--- @return void
function Hero60026_Skill3:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero60026_Skill3