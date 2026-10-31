--- @class Hero20004_Skill3 Defronowe
Hero20004_Skill3 = Class(Hero20004_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20004_Skill3:CreateInstance(id, hero)
    return Hero20004_Skill3(id, hero)
end

--- @return void
function Hero20004_Skill3:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero20004_Skill3