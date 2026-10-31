--- @class Hero20002_Skill3 Arien
Hero20002_Skill3 = Class(Hero20002_Skill3, BaseSkill)

--- @return BaseSkill
function Hero20002_Skill3:CreateInstance(id, hero)
    return Hero20002_Skill3(id, hero)
end

--- @return void
function Hero20002_Skill3:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero20002_Skill3