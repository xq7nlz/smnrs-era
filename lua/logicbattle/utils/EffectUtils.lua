--- @class EffectUtils
EffectUtils = {}

--- @return BaseEffect
--- @param initiator BaseHero
--- @param target BaseHero
--- @param type EffectType
--- @param duration number
function EffectUtils.CreateCCEffect(initiator, target, type, duration)
    ---@type  BaseEffect
    local ccEffect
    if type == EffectType.STUN then
        ccEffect = StunEffect(initiator, target)
    elseif type == EffectType.FREEZE then
        ccEffect = FreezeEffect(initiator, target)
    elseif type == EffectType.SLEEP then
        ccEffect = SleepEffect(initiator, target)
    elseif type == EffectType.PETRIFY then
        ccEffect = PetrifyEffect(initiator, target)
    else
        assert(false)
    end

    ccEffect:SetDuration(duration)
    return ccEffect
end

--- @return BaseEffect
--- @param initiator BaseHero
--- @param target BaseHero
--- @param type EffectType
--- @param duration number
--- @param amount number damage per round
--- Dot = damage over time
function EffectUtils.CreateDotEffect(initiator, target, type, duration, amount)
    ---@type DotEffect
    local dotEffect
    if type == EffectType.BURN then
        dotEffect = BurningEffect(initiator, target)
    elseif type == EffectType.POISON then
        dotEffect = PoisonEffect(initiator, target)
    elseif type == EffectType.BLEED then
        dotEffect = BleedEffect(initiator, target)
    end

    dotEffect:SetDotAmount(amount)
    dotEffect:SetDuration(duration)
    return dotEffect
end

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param type EffectType
--- @param duration number
function EffectUtils.CreateBlessEffect(initiator, target, type, duration)
    if EffectUtils.CanAddEffect(target, type, true) == false then
        return
    end

    if type == EffectType.BLESS then
        target.effectController:DispelDebuff()
    end
    ---@type BlessMarkEffect
    local markEffect = BlessMarkEffect(initiator, target)
    markEffect:SetDuration(duration)
    target.effectController:AddEffect(markEffect)
end

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param type EffectType
--- @param duration number
function EffectUtils.CreateCurseEffect(initiator, target, type, duration)
    if EffectUtils.CanAddEffect(target, type, false) == false then
        return
    end

    if type == EffectType.CURSE then
        target.effectController:DispelBuff()
    end
    ---@type CurseMarkEffect
    local markEffect = CurseMarkEffect(initiator, target)
    markEffect:SetDuration(duration)
    target.effectController:AddEffect(markEffect)
end

--- @return BaseEffect
--- @param target BaseHero
--- @param effectType EffectType
--- @param isBuff boolean
function EffectUtils.CanAddEffect(target, effectType, isBuff)
    if target:IsDead() then
        return false
    end

    if isBuff == true then
        --- Won't receive buff if cursed
        if target.effectController:IsTriggerMarkEffect(EffectType.CURSE_MARK, effectType) then
            return false
        end
    else
        --- Won't receive debuff if blessed
        if target.effectController:IsTriggerMarkEffect(EffectType.BLESS_MARK, effectType) then
            return false
        end
    end

    return true
end

return EffectUtils