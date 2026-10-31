--- @class Hero10011_Skill3 Jeronim
Hero10011_Skill3 = Class(Hero10011_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10011_Skill3:CreateInstance(id, hero)
    return Hero10011_Skill3(id, hero)
end

--- @return void
function Hero10011_Skill3:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero10011_Skill3