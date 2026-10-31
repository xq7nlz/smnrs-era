--- @class Hero40021_Skill3 Titi
Hero40021_Skill3 = Class(Hero40021_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40021_Skill3:CreateInstance(id, hero)
    return Hero40021_Skill3(id, hero)
end

--- @return void
function Hero40021_Skill3:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero40021_Skill3