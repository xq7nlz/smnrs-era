--- @class ClientActionResultUtils
ClientActionResultUtils = {}

--- @return boolean
--- @param type ActionResultType
function ClientActionResultUtils.IsDOT(type)
    return type == ActionResultType.BLEED_EFFECT
            or type == ActionResultType.BURNING_MARK
            or type == ActionResultType.POISON_EFFECT
            or type == ActionResultType.BURNING_EFFECT
end

--- @return boolean
--- @param actionResultType ActionResultType
function ClientActionResultUtils.IsDamageActionType(actionResultType)
    return actionResultType == ActionResultType.ATTACK
            or actionResultType == ActionResultType.USE_ACTIVE_DAMAGE_SKILL
            or actionResultType == ActionResultType.REFLECT_DAMAGE
            or actionResultType == ActionResultType.COUNTER_ATTACK
            --or actionResultType == ActionResultType.BOND_SHARE_DAMAGE
            or actionResultType == ActionResultType.BONUS_ATTACK
            or actionResultType == ActionResultType.SUB_ACTIVE_DAMAGE_SKILL
            --or actionResultType == ActionResultType.BOUNCING_DAMAGE
            or actionResultType == ActionResultType.MAIN_SUB_ACTIVE_DAMAGE_SKILL
            or ClientActionResultUtils.IsDOT(actionResultType)
end

--- @return boolean
--- @param type ActionResultType
function ClientActionResultUtils.IsHeal(type)
    return type == ActionResultType.HEAL_EFFECT
end

--- @return boolean
--- @param type ActionResultType
function ClientActionResultUtils.IsDealDamage(type)
    return type == ActionResultType.ATTACK
            or type == ActionResultType.USE_ACTIVE_DAMAGE_SKILL
            or type == ClientActionResultUtils.IsDOT(type)
end

--- @return boolean
--- @param type ActionResultType
function ClientActionResultUtils.IsChangeHp(type)
    return ClientActionResultUtils.IsHeal(type) or ClientActionResultUtils.IsDealDamage(type)
end

--- @return boolean
--- @param type ActionResultType
function ClientActionResultUtils.IsChangePower(type)
    return type == ActionResultType.ATTACK
            or type == ActionResultType.USE_ACTIVE_DAMAGE_SKILL
            or type == ActionResultType.BONUS_ATTACK
            or type == ActionResultType.CHANGE_POWER
end

--- @return boolean
--- @param type ActionResultType
function ClientActionResultUtils.IsChangeEffect(type)
    return type == ActionResultType.CHANGE_EFFECT
end

--- @return boolean
--- @param effectLogType EffectLogType
function ClientActionResultUtils.IsEffectHasIcon(effectLogType)
    return (effectLogType >= EffectLogType.CHANGE_ATTACK and effectLogType <= EffectLogType.CHANGE_POWER)
            --or (effectLogType >= EffectLogType.POISON and effectLogType <= EffectLogType.BURN)
            or (effectLogType >= EffectLogType.POISON and effectLogType <= EffectLogType.EXTRA_CC_DOT)
            or (effectLogType == EffectLogType.HEAL)
            or (effectLogType == EffectLogType.RESIST_HEAL)
            or effectLogType == EffectLogType.VENOM_STACK
end

--- @return boolean
--- @param effectLogType EffectLogType
function ClientActionResultUtils.IsEffectHasMark(effectLogType)
    return ClientActionResultUtils.IsEffectHasMarkOnBar(effectLogType)
            or ClientActionResultUtils.IsTalentBuffEffect(effectLogType)
            or effectLogType == EffectLogType.BOND_EFFECT
            or effectLogType == EffectLogType.NON_TARGETED_MARK
            or effectLogType == EffectLogType.SILENCE
            or effectLogType == EffectLogType.BLESS
            or effectLogType == EffectLogType.CURSE_MARK
            or effectLogType == EffectLogType.LIGHT_SHIELD
            or effectLogType == EffectLogType.BLESS_MARK
            or effectLogType == EffectLogType.CURSE
            or effectLogType == EffectLogType.DIVINE_SHIELD
            or effectLogType == EffectLogType.STAT_TRANSFER
end

--- @return boolean
--- @param effectLogType EffectLogType
function ClientActionResultUtils.IsTalentBuffEffect(effectLogType)
    return effectLogType == EffectLogType.TALENT_EXTRA_DAMAGE
            or effectLogType == EffectLogType.TALENT_INSTANT_KILL
            or effectLogType == EffectLogType.TALENT_RESIST_INSTANT_KILL
            or effectLogType == EffectLogType.TALENT_EXTRA_DOT_DAMAGE
            or effectLogType == EffectLogType.TALENT_CRITICAL_SILENT
            or effectLogType == EffectLogType.TALENT_BLOCK_SILENT
            or effectLogType == EffectLogType.TALENT_BLOCK_SILENT_CAST
            or effectLogType == EffectLogType.TALENT_REDUCE_CRITICAL
            or effectLogType == EffectLogType.TALENT_LESS_POWER
            or effectLogType == EffectLogType.TALENT_MORE_POWER
            or effectLogType == EffectLogType.TALENT_BLOCK_SHIELD
end

--- @param effectLogType
--- @return boolean
function ClientActionResultUtils.IsEffectHasMarkOnBar(effectLogType)
    return effectLogType == EffectLogType.HOLY_MARK
            or effectLogType == EffectLogType.BURNING_MARK
            or effectLogType == EffectLogType.DARK_MARK
            or effectLogType == EffectLogType.BLOOD_MARK
            or effectLogType == EffectLogType.DISEASE_MARK
            or effectLogType == EffectLogType.WATER_FRIENDLY
            or effectLogType == EffectLogType.WEAKNESS_POINT
            or effectLogType == EffectLogType.DROWNING_MARK
            or effectLogType == EffectLogType.DRYAD_MARK
            or effectLogType == EffectLogType.TAUNT_MARK
end

--- @param effectLogType
--- @return boolean
function ClientActionResultUtils.IsBuffTypeMarkOnBar(effectLogType)
    if ClientActionResultUtils.IsEffectHasMarkOnBar(effectLogType) == false then
        XDebug.Error(" EffectLogType is not mark type ", effectLogType)
    end
    if effectLogType == EffectLogType.HOLY_MARK
            or effectLogType == EffectLogType.BURNING_MARK
            or effectLogType == EffectLogType.DARK_MARK
            or effectLogType == EffectLogType.BLOOD_MARK
            or effectLogType == EffectLogType.DISEASE_MARK
            or effectLogType == EffectLogType.WEAKNESS_POINT
            or effectLogType == EffectLogType.DROWNING_MARK
            or effectLogType == EffectLogType.DRYAD_MARK
            or effectLogType == EffectLogType.TAUNT_MARK then
        return false
    end
    return true
end

--- @return boolean
function ClientActionResultUtils.IsEffectCC(effectLogType)
    return effectLogType == EffectType.STUN
            or effectLogType == EffectType.FREEZE
            or effectLogType == EffectType.SLEEP
            or effectLogType == EffectType.PETRIFY
end

--- @return boolean
--- @param persistentType EffectPersistentType
--- @param effectLogType EffectLogType
function ClientActionResultUtils.IsEffectShouldBeShowed(persistentType, effectLogType)
    return ClientActionResultUtils.IsEffectHasIcon(effectLogType, persistentType)
            or ClientActionResultUtils.IsEffectHasMark(effectLogType)
end

--- @return boolean
--- @param actionResultType ActionResultType
function ClientActionResultUtils.IsIndependentTurn(actionResultType)
    return actionResultType == ActionResultType.COUNTER_ATTACK
            or actionResultType == ActionResultType.BONUS_ATTACK
    --or actionResultType == ActionResultType.BOUNCING_DAMAGE
end

--- @return boolean
--- @param actionResultType ActionResultType
function ClientActionResultUtils.IsMergerTurn(actionResultType)
    return actionResultType == ActionResultType.ATTACK
            or actionResultType == ActionResultType.USE_ACTIVE_DAMAGE_SKILL
end

--- @return boolean
--- @param actionResultType ActionResultType
function ClientActionResultUtils.IsRegenerate(actionResultType)
    return actionResultType == ActionResultType.REGENERATE
end

--- @return boolean
--- @param actionResultType ActionResultType
function ClientActionResultUtils.IsKeepAliveAnim(actionResultType)
    return actionResultType == ActionResultType.REBORN
            or actionResultType == ActionResultType.REVIVE
end

--- @return boolean
--- @param clientActionType ClientActionType
function ClientActionResultUtils.IsAttackMultiTimes(clientActionType)
    return clientActionType == ClientActionType.BONUS_ATTACK
            or clientActionType == ClientActionType.BOUNCING_DAMAGE
end

return ClientActionResultUtils