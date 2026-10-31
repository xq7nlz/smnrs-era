--- @class PetrifyEffect : BaseEffect
PetrifyEffect = Class(PetrifyEffect, BaseEffect)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function PetrifyEffect:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.PETRIFY, false)
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function PetrifyEffect:OnEffectAdd(target)
    --- Only this effect remains in list
    self:SetBuffMultiplier(target, 1 - EffectConstants.PETRIFY_BUFF_REDUCTION)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function PetrifyEffect:OnEffectRemove(target)
    local effects = target.effectController:GetEffectWithType(EffectType.PETRIFY)
    if effects:Count() == 1 then
        --- Only this effect remains in list
        self:SetBuffMultiplier(target, 1)
    end
end

--- @return void
--- @param target BaseHero
function PetrifyEffect:SetBuffMultiplier(target, multiplier)
    local statChangerEffects = target.effectController:GetEffectWithType(EffectType.STAT_CHANGER)
    local i = 1
    while i <= statChangerEffects:Count() do
        local effect = statChangerEffects:Get(i)

        if effect.persistentType == EffectPersistentType.NON_PERSISTENT then
            if effect.isBuff == true then
                effect:SetMultiplier(multiplier)
            end
        end

        i = i + 1
    end
end