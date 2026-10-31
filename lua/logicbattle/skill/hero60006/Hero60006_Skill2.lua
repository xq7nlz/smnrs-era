--- @class Hero60006_Skill2 Hehta
Hero60006_Skill2 = Class(Hero60006_Skill2, BaseSkill)

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60006_Skill2:CreateInstance(id, hero)
    return Hero60006_Skill2(id, hero)
end

--- @return void
function Hero60006_Skill2:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero60006_Skill2