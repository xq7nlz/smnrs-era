--- @class Hero40007_Skill3 Noroth
Hero40007_Skill3 = Class(Hero40007_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
function Hero40007_Skill3:CreateInstance(id, hero)
    return Hero40007_Skill3(id, hero)
end

--- @return void
function Hero40007_Skill3:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero40007_Skill3