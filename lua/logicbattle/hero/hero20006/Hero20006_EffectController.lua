--- @class Hero20006_EffectController
Hero20006_EffectController = Class(Hero20006_EffectController, EffectController)

--- @return void
function Hero20006_EffectController:Ctor(hero)
    EffectController.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return EffectPersistentType
function Hero20006_EffectController:GetPersistentTypeBurningMark()
    if self.skill_4 ~= nil then
       return self.skill_4:PersistentType()
    end
    return EffectPersistentType.NON_PERSISTENT
end

--- @return number
--- @param skill BaseSkill
function Hero20006_EffectController:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

---------------------------------------- Manage effects ----------------------------------------
--- @return void
--- @param effect BaseEffect
function Hero20006_EffectController:AddEffect(effect)
    if effect:IsDotEffect() then
        if self.skill_4 ~= nil then
            effect.amount = self.skill_4:GetDotAmount(effect.amount)
        end
    end

    return EffectController.AddEffect(self, effect)
end