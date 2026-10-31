--- @class Hero40008_EffectController
Hero40008_EffectController = Class(Hero40008_EffectController, EffectController)

--- @return void
function Hero40008_EffectController:Ctor(hero)
    EffectController.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40008_EffectController:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

---------------------------------------- Manage effects ----------------------------------------
--- @return boolean
--- @param effect BaseEffect
function Hero40008_EffectController:CanAdd(effect)
    local baseResult = EffectController.CanAdd(self, effect)

    if self.skill_4 ~= nil and baseResult == true then
        local skillResult = self.skill_4:CanAddEffect(effect)
        return skillResult == true and baseResult == true
    end

    return baseResult
end