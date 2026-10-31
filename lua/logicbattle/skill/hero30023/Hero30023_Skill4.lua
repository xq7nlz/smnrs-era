--- @class Hero30023_Skill4 DrPlague
Hero30023_Skill4 = Class(Hero30023_Skill4, BaseSkill)

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30023_Skill4:CreateInstance(id, hero)
    return Hero30023_Skill4(id, hero)
end

--- @return void
function Hero30023_Skill4:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero30023_Skill4