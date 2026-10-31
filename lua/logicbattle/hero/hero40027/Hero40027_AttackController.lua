--- @class Hero40027_AttackController : AttackController
Hero40027_AttackController = Class(Hero40027_AttackController, AttackController)

--- @return void
--- @param hero BaseHero
function Hero40027_AttackController:Ctor(hero)
    AttackController.Ctor(self, hero)

    --- @type Hero40027_Skill2
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40027_AttackController:BindingWithSkill_2(skill)
    self.skill_2 = skill
end


