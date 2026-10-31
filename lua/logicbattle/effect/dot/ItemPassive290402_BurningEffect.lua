--- @class ItemPassive290402_BurningEffect : DotEffect
ItemPassive290402_BurningEffect = Class(ItemPassive290402_BurningEffect, DotEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function ItemPassive290402_BurningEffect:Ctor(initiator, target)
    DotEffect.Ctor(self, initiator, target, EffectType.ITEM_PASSIVE_BURN)
end

--- @return BurningEffectResult
function ItemPassive290402_BurningEffect:CreateEffectResult()
    return BurningEffectResult(self.initiator, self.myHero, self.duration)
end

--- @return TakeDamageReason
function ItemPassive290402_BurningEffect:GetTakeDamageReason()
    return TakeDamageReason.BURNING
end

--- @return void
--- @param target BaseHero
function ItemPassive290402_BurningEffect:OnEffectAdd(target)
    --- don't do anything
end