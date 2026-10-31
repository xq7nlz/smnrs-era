--- @class TargetPositionType
TargetPositionType = {
    SELF = 1,

    RANDOM = 10,
    ORDERED = 11,

    PREFER_FRONT_LINE = 20,
    PREFER_BACK_LINE = 21,

    LOWEST_HP = 30,
    HIGHEST_ATK = 31,
    LOWEST_DEF = 32,
    HIGHEST_HP_PERCENT = 33,
    HIGHEST_DEF = 34,
    HIGHEST_HP = 35,
    LOWEST_HP_PERCENT = 36,

    SAME_LINE = 41,
    NOT_SAME_LINE = 45,

    PREFER_EFFECT = 51,
    PREFER_HERO_CLASS = 52,

    INDEX_POSITION = 61,
    PREFER_HIGH_POSITION = 62,
}

return TargetPositionType