--- @class EffectType
EffectType = {
    --- Debuff: crowd control
    STUN = 1,
    FREEZE = 2,
    SLEEP = 3,
    PETRIFY = 4,

    --- Debuff: damage over time
    POISON = 10,
    BLEED = 11,
    BURN = 12,
    ITEM_PASSIVE_BURN = 13,

    --- Buff/ Debuff: change stats
    STAT_CHANGER = 20,

    --- Curse
    CURSE = 30, --- remove buff and not receive buff
    CURSE_MARK = 31, --- not receive buff

    SILENCE = 40, --- can't use skill
    RESIST_SILENCE = 41, --- can't take silence

    --- Mark type
    WEAKNESS_POINT = 100,
    HOLY_MARK = 101,
    WATER_FRIENDLY = 102,
    LIGHT_SHIELD = 103,
    DIVINE_SHIELD = 104,
    DRYAD_MARK = 105,
    DARK_MARK = 106,
    REVERSE_SHIELD = 107,
    FOCUS_MARK = 108,
    TAUNT_MARK = 109,
    VENOM_STACK = 110,
    BURNING_MARK = 111,
    MAGIC_SHIELD = 112,
    DROWNING_MARK = 113,
    BLOOD_MARK = 114,
    OCEANEE_MARK = 115,
    NON_TARGETED_MARK = 116,

    EXTRA_DAMAGE_TAKEN = 181,
    EXTRA_DAMAGE_TAKEN_BY_FACTION = 182,
    EXTRA_DAMAGE_TAKEN_WHEN_ATTACKED = 183,
    EXTRA_DAMAGE_TAKEN_WHEN_CC = 184,
    EXTRA_DOT_TAKEN_WHEN_CC = 185,

    DISEASE_MARK = 191,
    DISEASE_MARK_HEAL = 192,

    --- Bond
    BOND_EFFECT = 200,

    --- Basic stat
    STAT_CHANGER_ATTACK = 401,
    STAT_CHANGER_DEFENSE = 402,
    STAT_CHANGER_HP = 403,
    STAT_CHANGER_SPEED = 404,

    --- Crit stat
    STAT_CHANGER_CRIT_RATE = 410,
    STAT_CHANGER_CRIT_DAMAGE = 411,

    --- Accuracy stat
    STAT_CHANGER_ACCURACY = 420,
    STAT_CHANGER_DODGE = 421,

    --- Special attack stat
    STAT_CHANGER_PURE_DAMAGE = 430,
    STAT_CHANGER_SKILL_DAMAGE = 431,
    STAT_CHANGER_ARMOR_BREAK = 432,

    --- Special defense stat
    STAT_CHANGER_CC_RESISTANCE = 440,
    STAT_CHANGER_DAMAGE_REDUCTION = 441,

    --- Power
    STAT_CHANGER_POWER = 450,

    --- Bless
    BLESS = 500, --- remove debuff and not receive debuff
    BLESS_MARK = 501, --- not receive debuff

    HEAL = 510,
    RESIST_HEAL = 511, --- can't be healed
    THANATOS_HEAL = 512,
    BONUS_HEAL = 513,

    POWER_GAIN = 520,

    --- buff your self
    REBORN = 530,
    NERO_CLONE_PUPPET = 531,

    BONUS_DAMAGE_EXTRA_TURN = 551,
    BONUS_DAMAGE_EXTRA_TURN_AND_CC = 552,
    BONUS_ATTACK_BY_CLASS = 553,

    TALENT_BLOCK_SHIELD = 561,
    TALENT_EXTRA_DAMAGE = 562,
    TALENT_INSTANT_KILL = 563,
    TALENT_RESIST_INSTANT_KILL = 564,
    TALENT_EXTRA_DOT_DAMAGE = 565,
    TALENT_CRITICAL_SILENT = 566,
    TALENT_BLOCK_SILENT = 567,
    TALENT_BLOCK_SILENT_CAST = 571,
    TALENT_REDUCE_CRITICAL = 568,
    TALENT_LESS_POWER = 569,
    TALENT_MORE_POWER = 570,

    ---
    REFLECT = 600,

    REDUCE_DAMAGE_TAKEN_WHEN_CC = 611,
    LAST_CHANCE = 612,
    DRAGON_TRANSFORM = 613,

    STAT_TRANSFER = 620,
}

return EffectType