--- @class Hero40023_Skill3 HoundMaster
Hero40023_Skill3 = Class(Hero40023_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40023_Skill3:CreateInstance(id, hero)
    return Hero40023_Skill3(id, hero)
end

--- @return void
function Hero40023_Skill3:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)
end

return Hero40023_Skill3