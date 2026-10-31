--- @class Hero30007_SkillController
Hero30007_SkillController = Class(Hero30007_SkillController, SkillController)

--- @return void
--- @param hero BaseHero
function Hero30007_SkillController:Ctor(hero)
    SkillController.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30007_SkillController:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number
--- @param target BaseHero
--- @param type DamageFormulaType
function Hero30007_SkillController:GetBlockDamageRate(target, type)
    if self.skill_3 ~= nil then
        return self.skill_3:GetBlockDamageRate(target, type)
    end

    return SkillController.GetBlockDamageRate(self, target, type)
end