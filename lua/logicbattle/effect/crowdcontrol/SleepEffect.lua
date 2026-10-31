--- @class SleepEffect : BaseEffect
SleepEffect = Class(SleepEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function SleepEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.SLEEP, false)
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function SleepEffect:OnEffectAdd(target)
    --- Only this effect remains in list
    self:SetDebuffMultiplier(target, 1 + EffectConstants.SLEEP_DEBUFF_BONUS)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function SleepEffect:OnEffectRemove(target)
    local effects = target.effectController:GetEffectWithType(EffectType.SLEEP)
    if effects:Count() == 1 then
        --- Only this effect remains in list
        self:SetDebuffMultiplier(target, 1)
    end
end

--- @return void
--- @param target BaseHero
function SleepEffect:SetDebuffMultiplier(target, multiplier)
    local statChangerEffects = target.effectController:GetEffectWithType(EffectType.STAT_CHANGER)
    local i = 1
    while i <= statChangerEffects:Count() do
        local effect = statChangerEffects:Get(i)

        if effect.persistentType == EffectPersistentType.NON_PERSISTENT then
            if effect.isBuff == false then
                effect:SetMultiplier(multiplier)
            end
        end

        i = i + 1
    end
end