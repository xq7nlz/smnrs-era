--- @class OceaneeMark : BaseEffect
OceaneeMark = Class(OceaneeMark, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function OceaneeMark:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.OCEANEE_MARK, false)
    self:SetPersistentType(EffectPersistentType.MANUAL_REMOVE)

    --- @type BaseEffect
    self.debuffEffect = nil

    --- @type number
    self.debuffAmount = 0
end

--- @return void
--- @param effect BaseEffect
--- @param amount number
function OceaneeMark:SetDebuffEffect(effect, amount)
    if self.debuffEffect ~= nil then
        self.myHero.effectController:ForceRemove(self.debuffEffect)
    end

    self.debuffEffect = effect
    self.debuffAmount = amount
end

--- @return number
function OceaneeMark:GetDebuffAmount()
    return self.debuffAmount
end

--- @return string
function DotEffect:ToDetailString()
    return string.format("%s, DEBUFF_AMOUNT = %s", self:ToString(), self.debuffAmount)
end
