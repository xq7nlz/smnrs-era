--- @class Hero10009_Skill4 Lashna
Hero10009_Skill4 = Class(Hero10009_Skill4, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10009_Skill4:CreateInstance(id, hero)
    return Hero10009_Skill4(id, hero)
end

--- @return void
function Hero10009_Skill4:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero10009_Skill4