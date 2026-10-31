--- @class Hero20005_Skill4 Yin
Hero20005_Skill4 = Class(Hero20005_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20005_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero20005_Skill4:CreateInstance(id, hero)
    return Hero20005_Skill4(id, hero)
end

--- @return void
function Hero20005_Skill4:Init()
    self.myHero.battleHelper:SetMultiplierDamagePerDotEffect(self.data.multi_bonus_damage_per_effect, self.data.effect_check_type)
end

-----------------------------------------Battle---------------------------------------

return Hero20005_Skill4