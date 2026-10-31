--- @class Hero60020_Skill4 Hammer
Hero60020_Skill4 = Class(Hero60020_Skill4, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @param hero BaseHero
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60020_Skill4:CreateInstance(id, hero)
    return Hero60020_Skill4(id, hero)
end

--- @return void
function Hero60020_Skill4:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero60020_Skill4