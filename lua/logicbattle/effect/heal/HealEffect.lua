--- @class HealEffect : BaseEffect
HealEffect = Class(HealEffect, BaseEffect)
--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param healAmount number amount of hp is healed per turn
function HealEffect:Ctor(initiator, target, healAmount)
    BaseEffect.Ctor(self, initiator, target, EffectType.HEAL, true)

    --- @type number
    self.healAmount = healAmount
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
function HealEffect:UpdateBeforeRound()
    HealUtils.Heal(self.initiator, self.myHero, self.healAmount, HealReason.HEAL_EFFECT)
end

--- @return string
function HealEffect:ToDetailString()
    return string.format("%s, HEAL_AMOUNT = %s", self:ToString(), self.healAmount)
end
