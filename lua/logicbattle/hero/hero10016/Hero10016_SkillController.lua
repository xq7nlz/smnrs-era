--- @class Hero10016_SkillController
Hero10016_SkillController = Class(Hero10016_SkillController, SkillController)

--- @return void
--- @param hero BaseHero
function Hero10016_SkillController:Ctor(hero)
    SkillController.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero10016_SkillController:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return number
--- @param target BaseHero
--- @param type DamageFormulaType
function Hero10016_SkillController:GetBlockDamageRate(target, type)
    if self.skill_4 ~= nil then
        return self.skill_4:GetBlockDamageRate(target, type)
    end

    return SkillController.GetBlockDamageRate(self, target, type)
end