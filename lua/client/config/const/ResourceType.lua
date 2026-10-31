--- @class ResourceType
ResourceType = {
    --- inventory
    Hero = 1,
    Money = 2,
    ItemEquip = 3,
    ItemArtifact = 4,
    ItemStone = 5,
    ItemFragment = 6,
    HeroFragment = 7,
    SummonerExp = 8,
    DungeonItemPassiveBuff = 10,
    DungeonItemActiveBuff = 9,
    Avatar = 11,
    AvatarFrame = 12,
    EvolveFoodMaterial = 13,
    Skin = 14,
    SkinFragment = 15,
    SubscriptionPack = 16,
    CampaignQuickBattleTicket = 17,
    GROWTH_PACK = 18,
    EVENT_LUNAR_NEW_YEAR_WISH = 19,
    Talent = 20,
    IDLE_EFFECT = 24,
}

--- @class MoneyType
MoneyType = {
    STARTER_PACK_NONE = -3,
    None = -2,
    Random = -1,
    GOLD = 0,
    GEM = 1,
    VIP_POINT = 2,

    -- For leveling up, evolving hero
    MAGIC_POTION = 10,
    ANCIENT_POTION = 11,
    AWAKEN_BOOK = 12,
    MAGIC_CRYSTAL = 15,

    -- Gain when disassembling hero in Altar
    HERO_SHARD = 20,

    HERO_CHEST_NORMAL = 22,
    HERO_CHEST_PREMIUM = 23,

    REGRESSION_CURRENCY = 25,

    ARTIFACT_CHEST_DL = 26,
    ARTIFACT_CHEST_WFAN = 27,

    -- Casino
    CASINO_BASIC_CHIP = 30,
    CASINO_PREMIUM_CHIP = 31,
    CASINO_POINT = 32,

    -- Arena
    ARENA_CHEST_1 = 35,
    ARENA_CHEST_2 = 36,
    ARENA_CHEST_3 = 37,
    ARENA_TICKET = 40,
    ARENA_COIN = 41,
    ARENA_FREE_CHALLENGE_TURN = 42,
    ARENA_3V3_COIN = 43,

    ARENA_TEAM_TICKET = 45,
    ARENA_TEAM_COIN = 46,

    -- Summon
    SUMMON_BASIC_SCROLL = 50,
    SUMMON_HEROIC_SCROLL = 51,
    SUMMON_POINT = 52, -- accumulates when summon by scroll

    -- Prophet tree
    PROPHET_ORB = 60,
    PROPHET_WOOD = 61,

    EVENT_BLOSSOM_PLAY_TICKET = 62,
    EVENT_BLOSSOM_EXCHANGE_TICKET = 63,

    KAZETSU_BOSS_TICKET = 65,

    --Seasonal boss
    SEASONAL_BOSS_TICKET = 67,

    -- Friend
    FRIEND_POINT = 70,
    FRIEND_STAMINA = 71,

    EVENT_MAY_DAY_PLAY_TICKET = 72,
    EVENT_MAY_DAY_EXCHANGE_TICKET = 73,

    -- Raid
    RAID_GOLD_TURN = 75,
    RAID_MAGIC_POTION_TURN = 76,
    RAID_HERO_FRAGMENT_TURN = 77,

    EVENT_LUNAR_NEW_YEAR_TICKET = 78,
    EVENT_LUNAR_NEW_YEAR_LOTTERY_TICKET = 79,

    -- Dust
    STONE_DUST = 80, -- for upgrading and converting stone

    EVENT_SUMMER_PLAY_TICKET = 81,
    EVENT_SUMMER_EXCHANGE_TICKET = 82,

    -- Tower
    TOWER_STAMINA = 85,

    EVENT_QIXI_PLAY_TICKET = 86,
    EVENT_QIXI_EXCHANGE_TICKET = 87,

    -- Tavern
    QUEST_BASIC_SCROLL = 90, -- for obtaining a low-level quest
    QUEST_PREMIUM_SCROLL = 91, -- for obtaining a high-level quest
    TALENT_CORE = 95,
    -- Mastery
    MASTERY_POINT = 100, -- for upgrading mastery

    -- ThankGiving
    THANK_GIVING_DICE = 101,
    THANK_GIVING_PUMPKIN = 102,

    -- Summoner
    SUMMONER_ANCIENT_BOOK = 110, -- for evolving summoner

    DOMAIN_CHALLENGE_STAMINA = 112,
    DOMAIN_MARKET_COIN = 113,

    DOMAIN_CHEST_LEVEL_1 = 115,
    DOMAIN_CHEST_LEVEL_2 = 116,
    DOMAIN_CHEST_LEVEL_3 = 117,
    DOMAIN_CHEST_LEVEL_4 = 118,
    DOMAIN_CHEST_LEVEL_5 = 119,

    -- Guild
    GUILD_BASIC_COIN = 120,
    GUILD_PREMIUM_COIN = 121,
    GUILD_BOSS_STAMINA = 122,
    GUILD_DUNGEON_STAMINA = 123,
    GUILD_WAR_STAMINA = 124,

    -- Event Seasonal
    EVENT_SEASONAL_GIFT_BOX = 125,
    EVENT_SEASONAL_RED_BALL = 126,
    EVENT_SEASONAL_BLUE_BALL = 127,
    EVENT_SEASONAL_GREEN_BALL = 128,
    EVENT_SEASONAL_GREY_BALL = 129,

    -- Event guild quest
    EVENT_GUILD_QUEST_APPLE = 130,
    EVENT_GUILD_QUEST_PEAR = 131,

    EVENT_SERVER_OPEN_POINT = 135,
    UNION_POINT = 136,

    -- Event Boss Challenge
    EVENT_BOSS_CHALLENGE_TICKET = 137,

    -- Event shop
    TIER_1_SOUL = 140,
    TIER_2_SOUL = 141,
    TIER_3_SOUL = 142,

    ARENA_MARKET_UPGRADE_COIN = 150,
    GUILD_MARKET_UPGRADE_COIN = 151,
    BLACK_MARKET_UPGRADE_COIN = 152,
    ALTAR_MARKET_UPGRADE_COIN = 153,
    ARENA_TEAM_MARKET_UPGRADE_COIN = 154,

    EVENT_RATE_UP_SUMMON_POINT = 160,
    EVENT_NEW_HERO_ROSE = 165,
    EVENT_NEW_HERO_STAR = 166,
    EVENT_NEW_HERO_ELUNE_BLADE = 167,
    EVENT_NEW_HERO_TREASURE_COMPASS = 168,

    -- raise hero
    RAISED_HERO_UNLOCK_SLOT_CURRENCY = 170,
    SUPER_PEARL = 175,
    STAR_POINT = 176,

    -- event mid autumn
    EVENT_MID_AUTUMN_LANTERN = 180,
    EVENT_MID_AUTUMN_MOON_CAKE = 181,
    EVENT_MID_AUTUMN_LIGHT_LANTERN = 182,

    --event piece adventure
    EVENT_PIECE_ADVENTURE_COIN = 185,
    EVENT_PIECE_ADVENTURE_KEY = 186,

    -- event pass
    EVENT_ARENA_PASS_POINT = 190,
    EVENT_DAILY_QUEST_PASS_POINT = 191,
    BATTLE_PASS_EXP = 195,
    BATTLE_PASS_TOKEN = 196,

    WATER_ORB = 200,
    FIRE_ORB = 201,
    ABYSS_ORB = 202,
    NATURE_ORB = 203,
    DARK_ORB = 205,
    LIGHT_ORB = 204,
    SUN_ORB = 206,
    MOON_ORB = 207,

    -- Defense mode
    --DEFENSE_MODE_WATER_UPGRADE_POINT = 200,
    --DEFENSE_MODE_FIRE_UPGRADE_POINT = 201,
    --DEFENSE_MODE_ABYSS_UPGRADE_POINT = 202,
    --DEFENSE_MODE_NATURE_UPGRADE_POINT = 203,
    --DEFENSE_MODE_DARK_UPGRADE_POINT = 204,
    --DEFENSE_MODE_LIGHT_UPGRADE_POINT = 205,
    --DEFENSE_MODE_DREAM_UPGRADE_POINT = 206,
    --DEFENSE_MODE_CHAOS_UPGRADE_POINT = 207,
    --DEFENSE_MODE_UNBORN_UPGRADE_POINT = 208,
    --DEFENSE_MODE_LIBRARY_UPGRADE_POINT = 209,


    -- Event Halloween
    EVENT_HALLOWEEN_DICE = 210,
    EVENT_HALLOWEEN_PUMPKIN = 211,
    SKIN_BADGE = 215,

    -- Event Seasonal
    EVENT_SEASONAL_MOJITO = 216,

    EASTER_DAY_PLAY_TICKET = 217,
    EASTER_DAY_EXCHANGE_TICKET = 218,

    EVENT_CHRISTMAS_CANDY_BAR = 220,
    EVENT_CHRISTMAS_CANDLE = 221,
    EVENT_CHRISTMAS_LIGHTENED_CANDLE = 222,

    -- Event Seasonal
    EVENT_SEASONAL_MONEY = 223,
    EVENT_SEASONAL_GUN_POWER = 224,

    EVENT_BIRTHDAY_WHEEL = 225,
    EVENT_BIRTHDAY_RIVAL_POINT = 226,
    EVENT_BIRTHDAY_LEGACY_POINT = 227,

    EVENT_NEW_YEAR_Z_TICKET = 229,

    EVENT_NEW_YEAR_LOTTERY_TICKET = 230,
    EVENT_EASTER_POINT = 231,
    EVENT_EASTER_DICE = 232,
    EVENT_EASTER_SUPER_DICE = 233,
    EVENT_EASTER_WOOD_HAMMER = 234,
    EVENT_EASTER_SILVER_EGG = 235,
    EVENT_EASTER_YELLOW_EGG = 236,
    EVENT_EASTER_RAINBOW_EGG = 237,
    EVENT_EASTER_YELLOW_HAMMER = 238,
    EVENT_EASTER_RAINBOW_HAMMER = 239,

    EVENT_LUNAR_NEW_YEAR_DICE = 240,
    EVENT_LUNAR_NEW_FLAG = 241,
    EVENT_LUNAR_NEW_GUILD_POINT = 242,
    EVENT_LUNAR_NEW_YEAR_ENVELOPE = 243,
    SUMMON_ELITE_SCROLL = 244,
    EVENT_LUNAR_NEW_YEAR_CHALLENGE_STAMINA = 245,
    EVENT_LUNAR_NEW_YEAR_SUMMON_POINT = 246,
    EVENT_LUNAR_2022_LUCKY_COIN = 248,
    -- event valentine
    EVENT_VALENTINE_TICKET = 250,
    EVENT_VALENTINE_LOTTERY_TICKET = 251,
    EVENT_PUZZLE_PIECE = 252,

    EVENT_DRAGON_TOWER_HAMMER = 253,
    EVENT_DRAGON_TOWER_COIN = 254,
    EVENT_DRAGON_TOWER_INFINITY_COIN = 255,

    EVENT_LUNAR_2022_GROWTH_POINT = 249,

}

--- @class EquipmentType
EquipmentType = {
    Weapon = 1,
    Armor = 2,
    Helm = 3,
    Accessory = 4,
}

--- @class SlotEquipmentType
SlotEquipmentType = {
    Weapon = 1,
    Armor = 2,
    Helm = 3,
    Accessory = 4,
    Artifact = 5,
    Stone = 6,
    Skin = 7,
    Talent = 10,
    Talent2 = 11,
}

--- @class CasinoType
CasinoType = {
    Basic = 0,
    Premium = 1,
}

--- @class TavernQuestState
TavernQuestState = {
    WAITING = 0,
    DOING = 1,
    DONE = 2,
}

--- @class QuestState
QuestState = {
    INITIAL = 0,
    LOCKED = 1,
    LOCKED_NOT_CALCULATED = 2,
    DOING = 3,
    DONE_REWARD_NOT_CLAIM = 4,
    COMPLETED = 5,
    HIDDEN = 6,
    SHOWN_NOT_CALCULATED = 7,
    HIDDEN_AND_WAIT = 8
}

--- @class SortTypeHero
SortTypeHero = {
    LEVEL = 1,
    STAR = 2,
    POWER = 3,
}

--- @class GraphicQualityType
GraphicQualityType = {
    LOW = 1,
    MEDIUM = 2,
    HIGH = 3,
}

---@class RaidModeType
RaidModeType = {
    GOLD = 1,
    MAGIC_POTION = 2,
    HERO_FRAGMENT = 3,
}

---@class RewardState
RewardState = {
    NOT_AVAILABLE_TO_CLAIM = 0,
    AVAILABLE_TO_CLAIM = 1,
    CLAIMED = 2,
}

---@class SenderType
SenderType = {
    PLAYER = 0,
    SYSTEM = 1,
    ADMIN = 2,
    MODERATOR = 3,
}

---@class MailState
MailState = {
    NEW = 0,
    OPENED = 1,
    REWARD_RECEIVED = 2,
}

---@class EmailState
EmailState = {
    NOT_EXISTED = 0,
    VERIFYING = 1,
    VERIFIED = 2,
}

---@class PasswordResetState
PasswordResetState = {
    INITIAL = 0,
    VERIFYING = 1,
}

---@class ServerNotificationType
ServerNotificationType = {
    MAIL = 0,
    FRIEND_ADD = 1,
    FRIEND_DELETE = 2,
    FRIEND_REQUEST = 3,
    FRIEND_SEND_POINT = 4,
    SERVER_OPEN_UPDATED = 5,
    QUEST_UPDATED = 6,
    QUEST_COMPLETED = 7,
    IAP_UPDATED = 8,
    GUILD_MEMBER_ADDED = 9,
    GUILD_MEMBER_KICKED = 10,
    EVENT_UPDATED = 11,
    AVATAR_UPDATED = 12,
    ACHIEVEMENT_UPDATED = 13,
    ACHIEVEMENT_COMPLETED = 14,
    ARENA_BE_ATTACKED = 15,
    EVENT_SERVER_OPEN_COMPLETED = 16,
    EVENT_GUILD_QUEST_DONATE = 17,
    GUILD_WAR_REGISTERED = 18,
    RAISED_HERO_PENTAGRAM_UPDATE = 19,
    LINKING_SUPPORT_HERO_CHANGE = 21,
    FEATURE_UPDATED = 22,
    ARENA_TEAM_BE_ATTACKED = 23,
    COMEBACK_DATA_UPDATED = 24,

    DOMAINS_CREW_UPDATED = 25,
    DOMAINS_CREW_DISBANDED = 26,
    DOMAINS_CREW_MEMBER_ADDED = 27,
    DOMAINS_CREW_MEMBER_KICKED = 28,

    DOMAINS_CREW_CHALLENGE_START = 29,
    DOMAINS_CREW_CHALLENGE_UPDATED = 30,
    DOMAINS_CREW_MEMBER_READY_UPDATED = 31,
    DOMAINS_CREW_APPLICATION_UPDATED = 32,
    DOMAINS_CREW_INVITATION_UPDATED = 33,
    FIRST_PURCHASE_UPDATED = 35,
    EVENT_ADDED = 102,
}

---@class FeatureType
FeatureType = {
    CAMPAIGN = 1,
    SUMMON = 2,
    ALTAR = 3,
    BLACK_SMITH = 4,
    TOWER = 5,
    BLACK_MARKET = 6,
    TAVERN = 7,
    PROPHET_TREE = 8,
    DUNGEON = 9,
    GUILD = 10,
    CASINO = 11,
    ARENA = 12,
    HAND_OF_MIDAS = 13,
    INVENTORY = 14,
    SUMMONER = 15,
    MASTERY = 16,
    FRIENDS = 17,
    RAID = 18,
    HERO_LIST = 19,
    RAISE_LEVEL = 20,
    DEFENSE = 21,
    HERO_LINKING = 22,
    ARENA_TEAM = 23,
    REGRESSION = 24,
    EVOLVE_STAR_13 = 25,
    DOMAINS = 26,
    TALENT = 27,
    ITEM_REVOLUTION = 28,
    IDLE_EFFECT = 30,
    IAP_SHOP = 31,
    HERO_LINKING_SUPPORT = 32,
    GUILD_WAR = 33,
    EVOLVE_STAR_14 = 34,
    RECYCLE = 35,
    MAIL = 100,
    GUILD_DUNGEON = 101,
    GUILD_BOSS = 102,
}

---@class MinorFeatureType
MinorFeatureType = {
    CASINO_MULTIPLE_SPIN = 1,
    CASINO_PREMIUM_SPIN = 2,
    BATTLE_SPEED_UP = 3,
    BATTLE_SKIP = 4,
    SUMMON_ACCUMULATE = 5,
    CAMPAIGN_AUTO_TRAIN = 6,
    CAMPAIGN_QUICK_BATTLE = 7,
    BATTLE_SKIP_PRE = 8,
    BATTLE_SKIP_MIDDLE = 9,
    BATTLE_SPEED_UP_2 = 10,
    AUTO_BATTLE = 11,
    GIFT_CODE = 12,

}

---@class HeroFoodType
HeroFoodType = {
    MOON = 0,
    SUN = 1,
    WATER = 11,
    FIRE = 12,
    ABYSS = 13,
    NATURE = 14,
    LIGHT = 15,
    DARK = 16,
}

---@class TutorialFocus
TutorialFocus = {
    DRAG = 1,
    FOCUS = 2,
    FOCUS_CLICK = 3,
    AUTO_NEXT = 4,
    TAP_TO_CLICK = 5,
}

---@class TutorialStep
TutorialStep = {
    SUMMON_CLICK = 1,
    BASIC_SUMMON_INFO = 2,
    HEROIC_SUMMON_INFO = 3,
    FRIEND_SUMMON_INFO = 4,
    FREE_BASIC_SUMMON_CLICK = 5,
    FREE_HEROIC_SUMMON_CLICK = 6,
    BACK_SUMMON_CLICK = 7,
    CAMPAIGN_CLICK = 8,
    CAMPAIGN_BATTLE_CLICK = 9,
    CAMPAIGN_IDLE_REWARD_CLICK = 10,
    BACK_SUMMON_RESULT_CLICK = 11,
    FORMATION_SELECT_HERO_1 = 12,
    FORMATION_SELECT_HERO_2 = 13,
    FORMATION_BATTLE_CLICK = 14,
    NEXT_STAGE = 15,
    POSITION_1 = 16,
    POSITION_2 = 17,
    POSITION_3 = 18,
    POSITION_4 = 19,
    DEFEATED_FORGE_EQUIPMENT = 20,
    BLACK_SMITH_WEAPON = 21,
    BLACK_SMITH_ARMOR = 22,
    BLACK_SMITH_HELMET = 23,
    BLACK_SMITH_RING = 24,
    FORGE_CLICK = 25,
    BACK_BLACK_SMITH = 26,
    CLOSE_POPUP_REWARD = 27,
    BLACK_MARKET_CLICK = 28,
    BUY_HEROIC_SCROLL = 29,
    CLICK_NOTIFICATION_OPTION_1 = 30,
    CLICK_NOTIFICATION_OPTION_2 = 31,
    BACK_BLACK_MARKET = 32,
    CONTINUE_SUMMON = 33,
    CLICK_HERO_COLLECTION = 34,
    SELECT_HERO_IN_COLLECTION = 35,
    SELECT_TAB_EQUIP = 36,
    CLICK_AUTO_EQUIP = 37,
    BACK_HERO_INFO = 38,
    BACK_HERO_COLLECTION = 39,
    BATTLE_CLOSE = 40,
    STAGE10_INFO = 41,
    CLICK_TRAINING = 42,
    SELECT_HERO_TRAINING_1 = 43,
    SELECT_HERO_TRAINING_2 = 44,
    SAVE_TRAINING = 45,
    CLICK_LEVEL_UP_HERO = 46,
    BACK_CAMPAIGN = 47,
    FORMATION_DRAG_HERO = 48,
    CLOSE_AUTO_TEAM = 49,
    CLICK_RENAME = 50,
    OK_RENAME = 51,
    CLICK_LEVEL_UP_HERO_BACK = 52,
    TRAINING_INFO = 53,
    CLICK_QUEST = 54,
    CLICK_QUEST_TREE = 55,
    CLICK_MAIN_ACTION = 56,
    CLICK_QUEST_1 = 57,
    CLICK_GO = 58,
    CLICK_QUEST_COMPLETE = 59,
    CLICK_INVENTORY = 60,
    CLICK_TAB_FRAGMENT = 61,
    CLICK_HERO_FRAGMENT = 62,
    CLICK_SUMMON_HERO_FRAGMENT = 63,
    CLICK_SUMMONER = 64,
    CLICK_TAB_EVOLVE = 65,
    CLICK_EVOLVE = 66,
    SUMMONER_CLASS_1 = 67,
    SUMMONER_CLASS_2 = 68,
    SUMMONER_CLASS_3 = 69,
    SUMMONER_CLASS_4 = 70,
    SUMMONER_CLASS_5 = 71,
    CLICK_SWITCH_SUMMONER = 72,
    SWITCH_SUMMONER = 73,
    CLICK_SUMMON_ITEM = 74,
    CLICK_BACK_MAP = 75,
    SUMMONER_POWER = 76,
    SUMMONER_SKILL = 77,
    RESUME_BATTLE = 78,
    CLICK_BLACK_SMITH = 79,
    SUMMONER_BATTLE_INFO = 80,
    SUMMONER_ADD_POWER = 81,
    FORMATION_BUFF = 82,
    ALL_SUMMONER = 83,
    CLICK_SUMMON_BASIC = 84,
    CLICK_SUMMON_HEROIC = 85,
    REFUND_BUY_SCROLL = 86,
    PLEASE_CLICK_SUMMON_HEROIC = 87,
    INTRODUCE_HERO_SUMMONED = 88,
    SKIP_ALL_TUTORIAL = 89,
    TEN_HEROIC_SUMMON_CLICK = 90,
    DEFEATED_UPGRADE_HERO = 91,
    DEFEATED_SUMMON_HERO = 92,
    BATTLE_DEFEATED = 93,
    UPGRADE_HERO_WEAPON_SLOT = 94,
    UPGRADE_HERO_ARMOR_SLOT = 95,
    UPGRADE_HERO_HELMET_SLOT = 96,
    UPGRADE_HERO_RING_SLOT = 97,
    POSITION_SUMMONER = 98,
    INTRODUCE_TURN_MECHANIC = 99
}

---@class TutorialPivot
TutorialPivot = {
    TOP_LEFT = 1,
    TOP_RIGHT = 2,
    BOTTOM_LEFT = 3,
    BOTTOM_RIGHT = 4,
    CENTER = 5,
    CENTER_TOP = 6,
}

---@class TutorialHandType
TutorialHandType = {
    CLICK = 1,
    MOVE_CLICK = 2,
    MULTIPLE_CLICK = 3,
    CLICK_BOTTOM = 4,
}

---@class LimitedPackResetType
LimitedPackResetType = {
    RESET_BY_WEEK = 0,
    RESET_BY_MONTH = 1,
    RESET_BY_DAY = 2,
    RESET_BY_YEAR = 3,
}

--- @class NotificationType
NotificationType = {
    Close = 1,
    Ok = 2,
    YesNo = 3,
}

--- @class DOTweenEase
DOTweenEase = {
    Linear = 1,
    OutSine = 3,
}

--- @class ClientActionType
ClientActionType = {
    BASIC_ATTACK = 1,
    USE_SKILL = 2,
    NOTHING = 3,
    REBORN = 4,
    COUNTER_ATTACK = 5,
    BONUS_ATTACK = 6,
    BOUNCING_DAMAGE = 7,
}

--- @class CampaignDifficultLevel
CampaignDifficultLevel = {
    Normal = 1,
    Nightmare = 2,
    Hell = 3,
    Death = 4,
    Crazy = 5,
    Chaos = 6,
    Universe = 7,
    Godz = 8,
}

--- @class DisconnectReason
DisconnectReason = {
    EXCEED_CONNECTION = 0,
    INCOMPATIBLE_VERSION = 1,
    AUTHORIZATION_REQUIRED = 2,
    ANOTHER_DEVICE_LOGIN = 3,
    IDLE_TIMEOUT = 4,
    ADMINISTRATOR_KICK = 5,
    BLOCKED_USER = 6,
    INTERNAL_SERVER_ERROR = 7,
    MAINTENANCE = 8,

    OUT_GAME_LONG_TIME = 50,
    NO_NETWORK_CONNECTION = 91,
    CANT_PING_ANY_SERVER = 92,
    CANT_DOWNLOAD_GOOGLE_SCRIPT = 93,
    CANT_DOWNLOAD_LUA_ZIP = 94,
    CANT_DOWNLOAD_CSV_ZIP = 95,
    CANT_DOWNLOAD_MANIFEST_ASSET = 96,
    CANT_DOWNLOAD_BUNDLE_ASSET = 97,
    CANT_DOWNLOAD_BALANCER = 98,
}

--- @class SummonType
SummonType = {
    Basic = 0,
    Heroic = 1,
    Friendship = 2,
    Cumulative = 3,
    RateUp = 6,
    NewHero = 7,
    NewHero2 = 8,
    HeroRelease = 9,
    Kazetsu = 10
}

--- @class ChatMessageType
ChatMessageType = {
    PLAIN_TEXT = 0,
    GUILD_WAR_INVITE = 1,
    GUILD_RECRUIT = 2,
    ADMIN_MESSAGE = 3,
    MAINTENANCE_MESSAGE = 4,
    DOMAIN_CREW_RECRUIT = 5,
}

--- @class ChatChanel
ChatChanel = {
    WORLD = 0,
    GUILD = 1,
    RECRUIT = 2,
    SYSTEM = 3,

    DOMAINS_TEAM = 4,
    DOMAINS_RECRUIT = 5,
}

--- @class MarketType
MarketType = {
    BLACK_MARKET = 1,
    ALTAR_MARKET = 2,
    ARENA_MARKET = 3,
    ARENA_TEAM_MARKET = 4,
    EVENT_MARKET = 5,
    DOMAINS_MARKET = 6,
    GUILD_MARKET = 7,
}

--- @class GuildWarPhase
GuildWarPhase = {
    SPACE = 0,
    REGISTRATION = 1,
    SETUP_DEFENDER = 2,
    BATTLE = 3,
}

--- @class SkinRarity
SkinRarity = {
    DEFAULT = 0,
    COMMON = 1,
    UNCOMMON = 2,
    RARE = 3,
    LEGEND = 4,
}

--- @class ReloadDataType
ReloadDataType = {
    NONE = 1,
    OUT_GAME_LONG_TIME = 2,
    NEXT_DAY = 3,
}

--- @class AssetType
AssetType = {
    UI = "UI",
    Hero = "Hero",
    UIEffect = "UIEffect",
    HeroBattleEffect = "HeroBattleEffect",
    GeneralBattleEffect = "GeneralBattleEffect",
    Effect = "Effect",
    UIPool = "UIPool",
    Audio = "Audio",
    Texture = "Texture",
    Background = "Background",
    Battle = "Battle",
    GeneralBattleSound = "GeneralBattleSound",
    Config = "Config",
    Video = "Video",
    Material = "UIMaterials",
    Prefab = "Prefabs",
    DefenseBattleEffect = "DefenseBattleEffect",
    DefenseBattleSound = "DefenseBattleSound",
}

--- @class SceneConfig
SceneConfig = {
    HomeScene = "HomeScene",
    BattleScene = "BattleScene",
    BattleTestScene = "BattleTestScene",
    MatchWidthOrHeight = {
        min = 1.333,
        max = 2.005
    }
}

--- @class ClientConfigKey
ClientConfigKey = {
    TIME_LIFE = "time_life",
    DELAY_DESPAWN_ON_RELEASE = "delay_despawn",
    ANCHOR = "anchor",
    IS_SYNC_TARGET_LAYER = "is_sync_target_layer",
    IS_TARGET_CHILD = "is_target_child",
    MAIN_VISUAL = "main_visual",
    MAIN_VISUAL = "main_visual",
    BATTLE_EFFECT_TYPE = "battle_effect_type",

    DEFAULE_BATTLE_EFFECT = 1,
    SPINE_BATTLE_EFFECT = 2,
    DEFAULT_SPINE_ANIM = "default"
}

--- @class PackViewType
PackViewType = {
    RAW_PACK = 0,
    SUBSCRIPTION_PACK = 1,
    FIRST_TIME_PACK = 2,
    LIMITED_PACK = 3,
    EVENT_BUNDLE = 4,
    EVENT_HOT_DEAL = 5,
    FLASH_SALE_PACK = 6,
    STARTER_PACK = 7,
    GROWTH_PACK = 8,
    MASTER_BLACKSMITH = 9,
    ARENA_PASS = 10,
    DAILY_QUEST_PASS = 11,
    STARTER_PACK_NEW = 12,
    DAILY_LIMITED_PACK = 31,
    WEEKLY_LIMITED_PACK = 32,
    MONTHLY_LIMITED_PACK = 33,
    DAILY_LIMITED_HALLOWEEN_PACK = 34,
    DAILY_LIMITED_XMAS_PACK = 35,
    DAILY_LIMITED_NEW_YEAR = 36,
    ELITE_BUNDLE = 37,
    VALENTINE_BUNDLE = 38,
    NEW_HERO_BUNDLE = 39,
    DAILY_LIMITED_EASTER_PACK = 40,
    WELCOME_BACK_BUNDLE = 41,
    DAILY_LIMITED_BIRTHDAY = 42,
    EVENT_SKIN_BUNDLE_1 = 43,
    EVENT_SKIN_BUNDLE_2 = 44,
    HERO_RELEASE_BUNDLE = 45,
    FLASH_SALE_NEW = 46,
    SERVER_WEEK_BUNDLE = 47,
    KAZETSU_BUNDLE = 48,
    EASTER_BUNDLE = 49,
    BIRTHDAY_BUNDLE = 55,
    ZODIAC_BUNDLE = 56,
    SKIN_BUNDLE = 57,
    BLACK_FRIDAY_BUNDLE = 58,
    SKIN_CHALLENGE_BUNDLE = 59,
    EVENT_AIRYUU_BUNDLE = 60,
    EVENT_NEW_YEAR_BUNDLE = 61,
    EVENT_TOWER_OF_EITRI_BUNDLE = 62,
    EVENT_SEASONAL_BUNDLE = 63,
    EVENT_BOSS_CHALLENGE_BUNDLE = 64,
    EVENT_MID_AUTUMN_BUNDLE = 65,
    EVENT_HALLOWEEN_BUNDLE = 66,
    EVENT_PIECE_ADVENTURE_BUNDLE = 67,
    EVENT_THANKS_GIVING_BUNDLE = 68,
    EVENT_CHRISTMAS_BUNDLE = 69,
    EVENT_NEW_YEAR_2023_BUNDLE = 70,
    EVENT_LUNAR_NEW_YEAR_2024_BUNDLE = 71,
    EVENT_VALENTINE_2024_BUNDLE = 72,
    EVENT_EASTER_DAY_BUNDLE = 73,
    EVENT_SUMMER_DAY_BUNDLE = 74,
    EVENT_BLOSSOM_DAY_BUNDLE = 75,
    EVENT_QIXI_FESTIVAL_BUNDLE = 76,
    EVENT_MAY_DAY_BUNDLE = 77,
}

--- @class LeaderBoardType
LeaderBoardType = {
    CAMPAIGN = 1,
    TOWER = 2,
    DUNGEON = 3,
    FRIEND_RANKING = 4,
    GUILD_DUNGEON_RANKING = 5,
    GUILD_BOSS_RANKING = 6,
    GUILD_DUNGEON_SEASON_RANKING = 7,
    GUILD_WAR_SEASON_RANKING = 8,
    IGNATIUS_SEASON_RANKING = 9,
    LUNAR_BOSS_RANKING = 10,
    NEW_HERO_BOSS_RANKING = 11,
}

--- @class DefenseRestrictType
DefenseRestrictType = {
    WATER = 1,
    FIRE = 2,
    ABYSS = 3,
    NATURE = 4,
    DARK = 5,
    LIGHT = 6,
    DREAM = 7,
    CHAOS = 8,
    UNBORN = 9,
    LIBRARY = 10,
}

--- @class PurchaseResponseCode
PurchaseResponseCode = {
    Success = -1,
    PurchasingUnavailable = 0,
    ExistingPurchasePending = 1,
    ProductUnavailable = 2,
    SignatureInvalid = 3,
    UserCancelled = 4,
    PaymentDeclined = 5,
    DuplicateTransaction = 6,
    Unknown = 7
}

--- @class SungameIapResponseCode
SungameIapResponseCode = {
    SUCCESS = 1,
    NOT_SELECTED = 11,
    FAILED = 111,
    OTHER = 13,
    FROM_PENDING = 222,
}

--- @class CalculationReward
CalculationReward = {
    MultiVip = 1,
    MultiLevel = 2,
    AddVip = 3,
    AddLevel = 4,
}

--- @class CALCULATOR_TYPE
CALCULATOR_TYPE = {
    ADD = 1,
    MULTIPLY = 2,
}

--- @class FACTOR_TYPE
FACTOR_TYPE = {
    VIP_LEVEL = 1,
    LEVEL_SUMMON = 2,
}

--- @class IapShopTab
IapShopTab = {
    MONTHLY_CARD = 1,
    CUSTOMIZE_BUNDLE = 2,
    REGULAR_PACK = 3,
    LEVEL_PASS_1 = 4,
    LEVEL_PASS_2 = 5,
    ARENA_PASS = 6,
    RAW_PACK = 7,
    SKIN = 8,
}

--- @class IapShopRegularTab
IapShopRegularTab = {
    DAILY_DEAL = 1,
    WEEKLY_DEAL = 2,
    MONTHLY_DEAL = 3,
}

--- @class InjectorType
InjectorType = {
    RAISED_HERO = 20,

    -- event injector type
    -- value = 1000 * event type
    EVENT_MID_AUTUMN = 1024,
    EVENT_ARENA_PASS = 1027,
    EVENT_DAILY_QUEST_PASS = 1028,
    EVENT_HALLOWEEN = 1029,
    EVENT_CHRISTMAS = 1030,
    EVENT_NEW_YEAR = 1031,
    EVENT_LUNAR_NEW_YEAR = 1032,
    EVENT_EASTER_EGG = 1042,
}

--- @class FeatureState
FeatureState = {
    LOCK = 1,
    COMING_SOON = 2,
    UNLOCK = 3,
    MAINTAIN = 4,
}

--- @class HeroFoodRefundType
HeroFoodRefundType = {
    RANDOM_HERO = 0,
    SAME_FACTION = 1,
    SAME_HERO = 2,
    SPECIFIC_HERO = 3,
}

--- @class DomainMemberSearchType
DomainMemberSearchType = {
    FRIEND_ID = 1,
    FRIEND_LIST = 2,
    GUILD_MEMBER_LIST = 3,
}

--- @class TutorialStepID
TutorialStepID = {
    TUTORIAL_FAKE_BATTLE = 1000,
    TUTORIAL_SUMMON_10_CLICK = 1500,
    TUTORIAL_SUMMON_10 = 2000,
    TUTORIAL_CAMPAIGN_1 = 3000,
    TUTORIAL_POWER_UP = 4000,
    TUTORIAL_IDLE_REWARD = 5000,
    TUTORIAL_LEVEL_UP = 6000,
    TUTORIAL_END = 7000
}

--- @class StageStatus
StageStatus = {
    PASSED = -1,
    CURRENT = 0,
    LOCKED = 1,

    VALUE = function(stage, currentStage)
        if stage < currentStage then
            return StageStatus.PASSED
        elseif stage == currentStage then
            return StageStatus.CURRENT
        else
            return StageStatus.LOCKED
        end
    end,
}

--- @class FirebaseRemoteConfigKey
FirebaseRemoteConfigKey = {
    Campaign = "campaign",
    CampaignReward = "campaign_reward",
    Summon = "summon",
    WatchAd = "watch_ads",
    ProgressPack = "progress_pack",
    FirstTopUp = "first_top_up",
}

--- @class IapPackPriceType
IapPackPriceType = {
    FREE = 0,
    WATCH_ADS = 1,
    GEM = 2,
    DOLLAR = 3,
}

--- @class PopupMulti
PopupMulti = {
    DifficultRewardItem = 1,
    TrialBattleHistoryItem = 2,
    ServerBuildingProgress = 3,
    TowerOfEitriPopupQuestItem = 4,
}

--- @class MonthString
MonthString = {
    January = "january",
    February = "february",
    March = "march",
    April = "april",
    May = "may",
    June = "june",
    July = "july",
    August = "august",
    September = "september",
    October = "october",
    November = "november",
    December = "december",
}

--- @class MonthEnum
MonthEnum = {
    January = 1,
    February = 2,
    March = 3,
    April = 4,
    May = 5,
    June = 6,
    July = 7,
    August = 8,
    September = 9,
    October = 10,
    November = 11,
    December = 12,
}

--- @class Platform
Platform = {
    Android = "android",
    IOS = "ios",
    Unity = "unity",
    All = "all",
}

--- @class LanguageCode
LanguageCode = {
    DefaultLanguage = "en",
    English = "en",
    German = "de",
    French = "fr",
    Japanese = "ja",
    Korean = "ko",
    ChineseSimplified = "zhcn",
    ChineseTraditional = "zhtw",
    Russian = "ru",
    Portuguese = "br",
    Indonesian = "id",
    Spanish = "sp",
    Vietnamese = "vi",
}

--- @class CommunityEventButtonType
CommunityEventButtonType = {
    Facebook = 1,
    Discord = 2,
    Other = 3,
}

--- @class CommunityEventButtonPosition
CommunityEventButtonPosition = {
    BottomRight = "bottom_right",
    BottomLeft = "bottom_left",
}