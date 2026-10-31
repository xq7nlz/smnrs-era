--- @class ExtraDotWhenCC : BaseEffect
ExtraDotWhenCC = Class(ExtraDotWhenCC, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param amount number
function ExtraDotWhenCC:Ctor(initiator, target, amount)
    BaseEffect.Ctor(self, initiator, target, EffectType.EXTRA_DOT_TAKEN_WHEN_CC, false)

    --- @type number
    self.amount = amount
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function ExtraDotWhenCC:OnEffectAdd(target)
    target.effectController.effectListener:Register(EffectListenerType.TAKE_CC, self)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function ExtraDotWhenCC:OnEffectRemove(target)
    target.effectController.effectListener:Unregister(EffectListenerType.TAKE_CC, self)
end

--- @return void
--- @param effect BaseEffect
function ExtraDotWhenCC:OnTakeCCEffect(effect)
    local initiator = effect.initiator
    local duration = effect.duration

    local dotEffect = EffectUtils.CreateDotEffect(initiator, self.myHero, EffectType.BLEED, duration, self.amount)
    self.myHero.effectController:AddEffect(dotEffect)
end