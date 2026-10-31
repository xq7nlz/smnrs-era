--- @class Hero40002_SkillController
Hero40002_SkillController = Class(Hero40002_SkillController, SkillController)

--- @return void
--- @param hero BaseHero
function Hero40002_SkillController:Ctor(hero)
    SkillController.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40002_SkillController:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number
--- @param target BaseHero
--- @param type DamageFormulaType
function Hero40002_SkillController:GetBlockDamageRate(target, type)
    if self.skill_3 ~= nil then
        return self.skill_3:GetBlockDamageRate(target, type)
    end

    return SkillController.GetBlockDamageRate(self, target, type)
end