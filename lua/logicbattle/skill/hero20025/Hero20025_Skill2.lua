--- @class Hero20025_Skill2 Yirlal
Hero20025_Skill2 = Class(Hero20025_Skill2, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero20025_Skill2:CreateInstance(id, hero)
    return Hero20025_Skill2(id, hero)
end

--- @return void
function Hero20025_Skill2:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero20025_Skill2