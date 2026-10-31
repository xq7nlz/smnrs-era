--- @class Hero40009_Skill2 Sylph
Hero40009_Skill2 = Class(Hero40009_Skill2, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40009_Skill2:CreateInstance(id, hero)
    return Hero40009_Skill2(id, hero)
end

--- @return void
function Hero40009_Skill2:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero40009_Skill2