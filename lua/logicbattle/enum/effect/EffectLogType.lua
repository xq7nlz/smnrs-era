--- @class EffectLogType
EffectLogType = {
    --- Debuff: crowd control
    STUN = 1,
    FREEZE = 2,
    SLEEP = 3,
    PETRIFY = 4,

    --- Debuff: damage over time
    POISON = 10,
    BLEED = 11,
    BURN = 12,
    EXTRA_CC_DOT = 13,

    --- Buff/ Debuff: change stats
    STAT_CHANGER = 20,

    --- Curse
    CURSE = 30, --- remove buff and not receive buff
    CURSE_MARK = 31, --- not receive buff

    SILENCE = 40, --- can't use skill

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

    --- Buff/ Debuff: change stat
    CHANGE_ATTACK = 401,
    CHANGE_DEFENSE = 402,
    CHANGE_HP = 403,
    CHANGE_SPEED = 404,

    CHANGE_CRIT_RATE = 410,
    CHANGE_CRIT_DAMAGE = 411,

    CHANGE_ACCURACY = 420,
    CHANGE_DODGE = 421,

    CHANGE_PURE_DAMAGE = 430,
    CHANGE_SKILL_DAMAGE = 431,
    CHANGE_ARMOR_BREAK = 432,

    CHANGE_CC_RESISTANCE = 440,
    CHANGE_DAMAGE_REDUCTION = 441,

    CHANGE_POWER = 450,

    --- Bless
    BLESS = 500, --- remove debuff and not receive debuff
    BLESS_MARK = 501, --- not receive debuff

    HEAL = 510,
    RESIST_HEAL = 511, --- can't be healed
    THANATOS_HEAL = 512,

    --- buff your self
    REBORN = 530,
    NERO_CLONE_PUPPET = 531,

    BONUS_DAMAGE_EXTRA_TURN = 551,
    BONUS_DAMAGE_EXTRA_TURN_AND_CC = 552,
    BONUS_ATTACK_BY_CLASS = 553,

    --- talent buff effect
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

    --- nothing
    REFLECT = 600,

    REDUCE_DAMAGE_TAKEN_WHEN_CC = 611,
    LAST_CHANCE = 612,

    STAT_TRANSFER = 620,
}

return EffectLogType