--- @class Hero50021_Skill2 Archer
Hero50021_Skill2 = Class(Hero50021_Skill2, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @param hero BaseHero
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50021_Skill2:CreateInstance(id, hero)
    return Hero50021_Skill2(id, hero)
end

--- @return void
function Hero50021_Skill2:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero50021_Skill2