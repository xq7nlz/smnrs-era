--- @class BonusDamageExtraTurn : BaseEffect
BonusDamageExtraTurn = Class(BonusDamageExtraTurn, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function BonusDamageExtraTurn:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.BONUS_DAMAGE_EXTRA_TURN, true)

    --- @type number
    self.bonusDamage = nil

    --- @type number
    self.extraTurnToAffect = nil
end

--- @return void
--- @param bonusDamage number
--- @param extraTurnToAffect number
function BonusDamageExtraTurn:SetInfo(bonusDamage, extraTurnToAffect)
    self.bonusDamage = bonusDamage
    self.extraTurnToAffect = extraTurnToAffect
end

--- @return number
--- @param target BaseHero
--- @param damage number
--- @param numberExtraTurn number
function BonusDamageExtraTurn:OnExtraTurn(target, damage, numberExtraTurn)
    if numberExtraTurn == self.extraTurnToAffect then
        return (1 + self.bonusDamage) * damage
    end

    return damage
end

--- @return string
function BonusDamageExtraTurn:ToDetailString()
    return string.format("%s, bonusDamage = %s, extraTurnToAffect = %s",
            self:ToString(), self.bonusDamage, self.extraTurnToAffect)
end