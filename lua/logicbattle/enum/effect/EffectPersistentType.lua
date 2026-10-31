--- @class EffectPersistentType
EffectPersistentType = {
    NON_PERSISTENT = 1,
    NON_PERSISTENT_NOT_DISPELLABLE = 2,

    PERMANENT = 21,
    PERMANENT_REMOVABLE = 22,

    MANUAL_REMOVE = 31,
    DEPEND_ON_AURA = 32,
    DEPEND_ON_BOND = 34,

    LOST_WHEN_DEAD = 41,
    LOST_WHEN_REVIVE = 42,

    EFFECT_SPECIAL = 51,
    EFFECT_SPECIAL_UPDATABLE = 52,
}

return EffectPersistentType