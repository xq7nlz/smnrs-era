--- @class Hero60013_Skill2 DarkKnight
Hero60013_Skill2 = Class(Hero60013_Skill2, BaseSkill)

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60013_Skill2:CreateInstance(id, hero)
    return Hero60013_Skill2(id, hero)
end

--- @return void
function Hero60013_Skill2:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero60013_Skill2