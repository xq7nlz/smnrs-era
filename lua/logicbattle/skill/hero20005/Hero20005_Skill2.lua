--- @class Hero20005_Skill2 Yin
Hero20005_Skill2 = Class(Hero20005_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20005_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.bonusDotAmount = 0
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero20005_Skill2:CreateInstance(id, hero)
    return Hero20005_Skill2(id, hero)
end

--- @return void
function Hero20005_Skill2:Init()
    local statChangerSkillHelper = StatChangerSkillHelper(self, self.data.bonuses)
    statChangerSkillHelper:AddStatChangerEffect(self.myHero, self.myHero)

    self.myHero.skillController:SetBonusDotDamage(self.data.bonusDotAmount)
end

-----------------------------------------Battle---------------------------------------

return Hero20005_Skill2