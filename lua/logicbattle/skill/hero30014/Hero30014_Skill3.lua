--- @class Hero30014_Skill3 Kargoth
Hero30014_Skill3 = Class(Hero30014_Skill3, BaseSkill)

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30014_Skill3:CreateInstance(id, hero)
    return Hero30014_Skill3(id, hero)
end

--- @return void
function Hero30014_Skill3:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero30014_Skill3