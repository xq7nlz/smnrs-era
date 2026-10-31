--- @class Hero60011_Skill2 Vera
Hero60011_Skill2 = Class(Hero60011_Skill2, BaseSkill)

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60011_Skill2:CreateInstance(id, hero)
    return Hero60011_Skill2(id, hero)
end

--- @return void
function Hero60011_Skill2:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero60011_Skill2