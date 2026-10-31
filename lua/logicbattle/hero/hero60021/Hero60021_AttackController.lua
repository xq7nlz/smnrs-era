--- @class Hero60021_AttackController
Hero60021_AttackController = Class(Hero60021_AttackController, AttackController)

--- @return void
--- @param hero BaseHero
function Hero60021_AttackController:Ctor(hero)
    AttackController.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero60021_AttackController:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return List<BaseActionResult>, boolean  turn of this hero should be ended or not
--- @param targetList List<BaseHero>
function Hero60021_AttackController:Attack(targetList)
    local attackResults, isEndTurn = AttackController.Attack(self, targetList)

    if self.skill_2 ~= nil then
        isEndTurn = self.skill_2:ShouldEndTurn()
    end
    return attackResults, isEndTurn
end