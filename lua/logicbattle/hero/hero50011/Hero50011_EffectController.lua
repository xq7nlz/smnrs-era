--- @class Hero50011_EffectController
Hero50011_EffectController = Class(Hero50011_EffectController, EffectController)

--- @return void
--- @param hero BaseHero
function Hero50011_EffectController:Ctor(hero)
    EffectController.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero50011_EffectController:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number
function Hero50011_EffectController:CountDebuffEffect()
    local numberDebuff = 0

    local i = 1
    while i <= self.effectList:Count() do
        local effect = self.effectList:Get(i)
        if effect.isBuff == false then
            numberDebuff = numberDebuff + 1
        end
        i = i + 1
    end

    i = 1
    while i <= self.permanentEffectList:Count() do
        local effect = self.permanentEffectList:Get(i)
        if effect.isBuff == false then
            numberDebuff = numberDebuff + 1
        end
        i = i + 1
    end

    return numberDebuff
end

--- @return boolean
--- @param effect BaseEffect
function Hero50011_EffectController:AddEffect(effect)
    local isEffectAdded = EffectController.AddEffect(self, effect)

    if isEffectAdded == true then
        if self.skill_2 ~= nil then
            self.skill_2:OnEffectAdded(effect)
        end
    end

    return isEffectAdded
end