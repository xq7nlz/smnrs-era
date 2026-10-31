--- @class Hero10011_SkillController
Hero10011_SkillController = Class(Hero10011_SkillController, SkillController)

--- @return void
--- @param hero BaseHero
function Hero10011_SkillController:Ctor(hero)
    SkillController.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero10011_SkillController:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero10011_SkillController:UseActiveSkill()
    local attackResults, isEndTurn = SkillController.UseActiveSkill(self)

    if self.skill_4 ~= nil then
        isEndTurn = self.skill_4:ShouldEndTurn()
    end

    return attackResults, isEndTurn
end