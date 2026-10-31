--- @class DamageUtils
DamageUtils = {}

--- @return boolean
--- @param reason TakeDamageReason
function DamageUtils.IsNormalDamage(reason)
    if reason == TakeDamageReason.ATTACK_DAMAGE or reason == TakeDamageReason.SKILL_DAMAGE then
        return true
    end
    return false
end

--- @return boolean
--- @param reason TakeDamageReason
function DamageUtils.IsBondDamage(reason)
    if reason == TakeDamageReason.BOND_DAMAGE or reason == TakeDamageReason.BOND_DAMAGE_DOT then
        return true
    end
    return false
end

--- @return boolean
--- @param reason TakeDamageReason
function DamageUtils.IsInstantKillDamage(reason)
    if reason == TakeDamageReason.INSTANT_KILL then
        return true
    end
    return false
end

--- @return boolean
--- @param reason TakeDamageReason
function DamageUtils.IsDotDamage(reason)
    if reason == TakeDamageReason.BLEED or reason == TakeDamageReason.POISON or reason == TakeDamageReason.BURNING then
        return true
    end
    return false
end

--- @return boolean
--- @param reason TakeDamageReason
function DamageUtils.IsDamageThroughFormula(reason)
    if DamageUtils.IsNormalDamage(reason) == true or DamageUtils.IsDotDamage() == true or
            reason == TakeDamageReason.SUB_ACTIVE_DAMAGE or reason == TakeDamageReason.COUNTER_ATTACK_DAMAGE then
        return true
    end
    return false
end

return DamageUtils