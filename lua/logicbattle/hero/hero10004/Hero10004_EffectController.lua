--- @class Hero10004_EffectController
Hero10004_EffectController = Class(Hero10004_EffectController, EffectController)

--- @return void
function Hero10004_EffectController:Ctor(hero)
    EffectController.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero10004_EffectController:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return boolean
--- @param effect BaseEffect
function Hero10004_EffectController:CanAdd(effect)
    if self.skill_4 == nil or self.skill_4:CanAdd(effect) then
        return EffectController.CanAdd(self, effect)
    else
        return false
    end
end