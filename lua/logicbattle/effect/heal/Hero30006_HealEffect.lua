--- @class Hero30006_HealEffect : BaseEffect
Hero30006_HealEffect = Class(Hero30006_HealEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param healAmount number amount of hp is healed per turn
function Hero30006_HealEffect:Ctor(initiator, target, healAmount)
    BaseEffect.Ctor(self, initiator, target, EffectType.THANATOS_HEAL, true)

    --- @type number
    self.healAmount = healAmount

    self:SetPersistentType(EffectPersistentType.NON_PERSISTENT)
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
function Hero30006_HealEffect:UpdateBeforeRound()
    HealUtils.Heal(self.initiator, self.myHero, self.healAmount, HealReason.THANATOS_HEAL_EFFECT)
end

--- @return string
function Hero30006_HealEffect:ToDetailString()
    return string.format("%s, THANATOS_HEAL_AMOUNT = %s", self:ToString(), self.healAmount)
end
