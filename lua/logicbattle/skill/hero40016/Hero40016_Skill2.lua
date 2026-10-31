--- @class Hero40016_Skill2 Roo
Hero40016_Skill2 = Class(Hero40016_Skill2, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40016_Skill2:CreateInstance(id, hero)
    return Hero40016_Skill2(id, hero)
end

--- @return void
function Hero40016_Skill2:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero40016_Skill2