--- @class Hero40017_Skill4 Ktul
Hero40017_Skill4 = Class(Hero40017_Skill4, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40017_Skill4:CreateInstance(id, hero)
    return Hero40017_Skill4(id, hero)
end

--- @return void
function Hero40017_Skill4:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero40017_Skill4