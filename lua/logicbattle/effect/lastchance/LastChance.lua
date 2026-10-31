--- @class LastChance : BaseEffect
LastChance = Class(LastChance, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function LastChance:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.LAST_CHANCE, true)

    --- @type number
    self.triggerChance = 0

    --- @type number
    self.triggerNumberMax = 0

    --- @type number
    self.numberTrigger = 0

    --- @type number
    self.powerGain = 0
end

--- @return void
--- @param triggerChance number
--- @param triggerNumber number
function LastChance:SetLastChance(triggerChance, triggerNumber, powerGain)
    self.triggerChance = triggerChance
    self.triggerNumberMax = triggerNumber
    self.powerGain = powerGain
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function LastChance:OnEffectAdd(target)
    target.effectController.effectListener:Register(EffectListenerType.LAST_CHANCE, self)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function LastChance:OnEffectRemove(target)
    target.effectController.effectListener:Unregister(EffectListenerType.LAST_CHANCE, self)
end

--- @return number delta of damage
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function LastChance:OnLastChance(initiator, reason, damage)
    if damage >= self.myHero.hp:GetValue() then
        if self.numberTrigger < self.triggerNumberMax and self.myHero.randomHelper:RandomRate(self.triggerChance) then
            self.numberTrigger = self.numberTrigger + 1
            self.myHero.power:Gain(self.myHero, self.powerGain)

            if self.myHero.hp:GetValue() > 1 then
                return self.myHero.hp:GetValue() - 1
            else
                return 0
            end
        end
    end

    return damage
end

--- @return string
function LastChance:ToDetailString()
    return string.format("%s, triggerChance = %s", self:ToString(), self.triggerChance)
end