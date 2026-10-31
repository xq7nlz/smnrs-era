--- @class StatType
StatType = {
    --- Basic stat
    ATTACK = 1,
    DEFENSE = 2,
    HP = 3,
    SPEED = 4,

    --- Crit stat
    CRIT_RATE = 10,
    CRIT_DAMAGE = 11,

    --- Accuracy stat
    ACCURACY = 20,
    DODGE = 21,

    --- Special attack stat
    PURE_DAMAGE = 30,
    SKILL_DAMAGE = 31,
    ARMOR_BREAK = 32,
    REDUCE_DAMAGE_REDUCTION = 33,

    --- Special defense stat
    CC_RESISTANCE = 40,
    DAMAGE_REDUCTION = 41,

    --- Power
    POWER = 50
}

--- @return boolean
function StatType.IsValidType(statType)
    if StatType.ATTACK <= statType and statType <= StatType.SPEED then
        return true
    elseif StatType.CRIT_RATE <= statType and statType <= StatType.CRIT_DAMAGE then
        return true
    elseif StatType.ACCURACY <= statType and statType <= StatType.DODGE then
        return true
    elseif StatType.PURE_DAMAGE <= statType and statType <= StatType.REDUCE_DAMAGE_REDUCTION then
        return true
    elseif StatType.CC_RESISTANCE <= statType and statType <= StatType.DAMAGE_REDUCTION then
        return true
    elseif statType == StatType.POWER then
        return true
    end

    return false
end

return StatType