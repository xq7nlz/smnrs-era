--- @class Hero40027_DragonTransformEffect : BaseEffect
Hero40027_DragonTransformEffect = Class(Hero40027_DragonTransformEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function Hero40027_DragonTransformEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.DRAGON_TRANSFORM, true)
    self:SetPersistentType(EffectPersistentType.MANUAL_REMOVE)

    --- @type boolean
    self.isCanTransform = false
end

--- @return void
--- for updating logic
function Hero40027_DragonTransformEffect:UpdateBeforeRound()
end

--- @return void
--- for updating duration
function Hero40027_DragonTransformEffect:UpdateAfterRound()
    if self.myHero:IsDead() == false then
        self:DecreaseDuration()
        if self:IsShouldRemove() then
            if self.isCanTransform == false then
                self.isShouldRemove = false
                self.isCanTransform = true
            end
        end

        if self.isCanTransform then
            self:TransformHuman()
        end
    end
end

--- @return void
function Hero40027_DragonTransformEffect:TransformHuman()
    self.myHero.effectController:ForceRemove(self)
    self.duration = -1

    self.myHero:OnTransform(false)
end

--- @return string
function Hero40027_DragonTransformEffect:ToDetailString()
    return string.format("%s, DRAGON_FORM %s", self:ToString(), self.myHero:ToString())
end

return Hero40027_DragonTransformEffect