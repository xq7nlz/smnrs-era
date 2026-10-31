--- @class Hero40003_Skill3 Areien
Hero40003_Skill3 = Class(Hero40003_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
function Hero40003_Skill3:CreateInstance(id, hero)
    return Hero40003_Skill3(id, hero)
end

--- @return void
function Hero40003_Skill3:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero40003_Skill3