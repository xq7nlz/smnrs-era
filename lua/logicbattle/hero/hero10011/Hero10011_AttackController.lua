--- @class Hero10011_AttackController
Hero10011_AttackController = Class(Hero10011_AttackController, AttackController)

--- @return void
--- @param hero BaseHero
function Hero10011_AttackController:Ctor(hero)
    AttackController.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero10011_AttackController:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number
--- @param skill BaseSkill
function Hero10011_AttackController:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return List<BaseActionResult>, boolean  turn of this hero should be ended or not
--- @param targetList List<BaseHero>
function Hero10011_AttackController:Attack(targetList)
    local attackResults, isEndTurn = AttackController.Attack(self, targetList)

    if self.skill_2 ~= nil then
        self.skill_2:AfterAttack()
    end

    if self.skill_4 ~= nil then
        isEndTurn = self.skill_4:ShouldEndTurn()
    end
    return attackResults, isEndTurn
end