--- @class DryadMark : BaseEffect
DryadMark = Class(DryadMark, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function DryadMark:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.DRYAD_MARK, false)

    --- @type number
    self.reduceHeal = 0
end

--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function DryadMark:OnEffectAdd(target)
    target.effectController.effectListener:Register(EffectListenerType.HEAL, self)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function DryadMark:OnEffectRemove(target)
    target.effectController.effectListener:Unregister(EffectListenerType.HEAL, self)
end

--- @return number
--- @param initiator BaseHero
--- @param reason HealReason
--- @param healAmount number
function DryadMark:OnHeal(initiator, reason, healAmount)
    if self.initiator:IsDead() == false and reason ~= HealReason.DRYAD_MARK then
        local canHeal
        local stealHealValue = healAmount * self.reduceHeal

        canHeal, stealHealValue = HealUtils.Heal(self.initiator, self.initiator, stealHealValue, HealReason.DRYAD_MARK)
        if canHeal then
            local result = DryadResult(self.myHero, self.initiator, stealHealValue)
            ActionLogUtils.AddLog(self.myHero.battle, result)
        end
        return -stealHealValue
    end

    return 0
end

function DryadMark:SetReduceHeal(reduceHeal)
    self.reduceHeal = reduceHeal
end

--- @return string
function DryadMark:ToDetailString()
    return string.format("%s, REDUCE_HEAL = %s", self:ToString(), self.reduceHeal)
end
