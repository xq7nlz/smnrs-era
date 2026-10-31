--- @class VenomStack : DotEffect
VenomStack = Class(VenomStack, DotEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function VenomStack:Ctor(initiator, target)
    DotEffect.Ctor(self, initiator, target, EffectType.VENOM_STACK, false)
    self:SetPersistentType(EffectPersistentType.EFFECT_SPECIAL_UPDATABLE)
end

--- @return VenomStackResult
function VenomStack:CreateEffectResult()
    return VenomStackResult(self.initiator, self.myHero, self.duration)
end

--- @return TakeDamageReason
function VenomStack:GetTakeDamageReason()
    return TakeDamageReason.VENOM_STACK
end