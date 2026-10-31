--- @class Hero60015_Skill4 Murath
Hero60015_Skill4 = Class(Hero60015_Skill4, BaseSkill)

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60015_Skill4:CreateInstance(id, hero)
    return Hero60015_Skill4(id, hero)
end

--- @return void
function Hero60015_Skill4:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero60015_Skill4