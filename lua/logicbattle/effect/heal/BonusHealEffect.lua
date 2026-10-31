--- @class BonusHealEffect : BaseEffect
BonusHealEffect = Class(BonusHealEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function BonusHealEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.BONUS_HEAL, true)

    --- @type number
    self.bonusHeal = 0
end

--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function BonusHealEffect:OnEffectAdd(target)
    self.myHero.effectController.effectListener:Register(EffectListenerType.HEAL, self)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function BonusHealEffect:OnEffectRemove(target)
    self.myHero.effectController.effectListener:Unregister(EffectListenerType.HEAL, self)
end

--- @return number
--- @param initiator BaseHero
--- @param reason HealReason
--- @param healAmount number
function BonusHealEffect:OnHeal(initiator, reason, healAmount)
    if self.myHero:IsDead() then
        return 0
    end

    if self.initiator:IsDead() then
        return 0
    end
    
    return healAmount * self.bonusHeal
end

function BonusHealEffect:SetBonusHeal(bonusHeal)
    self.bonusHeal = bonusHeal
end

--- @return string
function BonusHealEffect:ToDetailString()
    return string.format("%s, BONUS_HEAL = %s", self:ToString(), self.bonusHeal)
end
