--- @type UnityEngine_Animator
local U_Animator = UnityEngine.Animator

--- @class BattleTextLogUtil
BattleTextLogUtil = {
    DAMAGE_FONT_ASSET = ResourceLoadUtils.LoadFontAsset("battle_damage"),
    CRIT_DAMAGE_FONT_ASSET = ResourceLoadUtils.LoadFontAsset("battle_crit"),
    HEAL_FONT_ASSET = ResourceLoadUtils.LoadFontAsset("battle_healing"),
    OTHER_FONT_ASSET = ResourceLoadUtils.LoadFontAsset("battle_other"),
    EXECUTE_FONT_ASSET = ResourceLoadUtils.LoadFontAsset("battle_lethal"),

    NORMAL_FONT_SIZE = 6.5,
    FOLLOW_FONT_SIZE = 5,
    LOG_TIME = 1.5,
    DELAY_LOG_FOLLOW = 0.4,
    OFFSET_LOG_FOLLOW = 0.4,
    STATUS_FONT_SIZE = 5,

    DAMAGE_HASH = U_Animator.StringToHash("damage"),
    CRIT_HASH = U_Animator.StringToHash("crit"),
    HEAL_HASH = U_Animator.StringToHash("heal"),
    MISS_HASH = U_Animator.StringToHash("miss"),
    MISS_FORMAT = "Miss",
    BLOCK_FORMAT = "Block",
    HEAL_FORMAT = "+%d",
    DAMAGE_FORMAT = "-%d",
    GLANCING_FORMAT = "Glancing",
    RESIST_FORMAT = "Resist",
    RESIST_EXECUTE_FORMAT = "<s>EXECUTE</s>",
    EXECUTE_FORMAT = "EXECUTE",
}