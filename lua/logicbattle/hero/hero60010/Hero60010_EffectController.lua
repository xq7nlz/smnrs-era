--- @class Hero60010_EffectController
Hero60010_EffectController = Class(Hero60010_EffectController, EffectController)

--- @return void
function Hero60010_EffectController:Ctor(hero)
    EffectController.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero60010_EffectController:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

---------------------------------------- Manage effects ----------------------------------------
--- @return void
--- @param effect BaseEffect
function Hero60010_EffectController:AddEffect(effect)
    local canAdd = EffectController.AddEffect(self, effect)

    if canAdd == true then
        if self.skill_2 ~= nil then
            self.skill_2:AddEffect(effect)
        end
    end

    return canAdd
end