--- @class Hero20023_Skill3 Kaboom
Hero20023_Skill3 = Class(Hero20023_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero20023_Skill3:CreateInstance(id, hero)
    return Hero20023_Skill3(id, hero)
end

--- @return void
function Hero20023_Skill3:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero20023_Skill3