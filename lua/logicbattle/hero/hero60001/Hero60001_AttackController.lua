--- @class Hero60001_AttackController
Hero60001_AttackController = Class(Hero60001_AttackController, AttackController)

--- @return void
--- @param hero BaseHero
function Hero60001_AttackController:Ctor(hero)
    AttackController.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero60001_AttackController:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return List<BaseActionResult>, boolean  turn of this hero should be ended or not
--- @param targetList List<number, BaseHero>
function Hero60001_AttackController:Attack(targetList)
    local attackResults, isEndTurn = AttackController.Attack(self, targetList)

    if self.skill_4 ~= nil then
        isEndTurn = self.skill_4:ShouldEndTurn()
    end
    return attackResults, isEndTurn
end