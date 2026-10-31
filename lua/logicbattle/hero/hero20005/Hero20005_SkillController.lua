--- @class Hero20005_SkillController
Hero20005_SkillController = Class(Hero20005_SkillController, SkillController)

--- @return void
--- @param hero BaseHero
function Hero20005_SkillController:Ctor(hero)
    SkillController.Ctor(self, hero)

    --- @type number
    self.bonus_dot_damage = 0
end

--- @return void
--- @param bonus number
function Hero20005_SkillController:SetBonusDotDamage(bonus)
    self.bonus_dot_damage = bonus
end

--- @return number
function Hero20005_SkillController:GetBonusDotDamage()
    return self.bonus_dot_damage
end