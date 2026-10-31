--- @class TakeDamageReason
TakeDamageReason = {
    ATTACK_DAMAGE = 1,
    SKILL_DAMAGE = 2,
    COUNTER_ATTACK_DAMAGE = 3,
    SUB_ACTIVE_DAMAGE = 4,
    MAIN_SUB_ACTIVE_DAMAGE = 5,

    BREAK_FREEZE = 11,
    POISON = 12,
    BLEED = 13,
    BURNING = 14,

    REFLECT_DAMAGE = 21,

    SPLASH_DAMAGE = 26,
    BOUNCING_DAMAGE = 27,

    --- damage share from bond
    BOND_DAMAGE_DOT = 31,
    BOND_DAMAGE = 32,

    INSTANT_KILL = 101,
    DROWNING_KILL = 102,

    VENOM_STACK = 111
}

return TakeDamageReason
