--- @type string
PRODUCT_VERSION = "1.3.1"
--- @type boolean
IS_CLIENT_RUNNING = true
--- @type UnityEngine_RuntimePlatform
PLATFORM = U_Application.platform
--- @type string
VERSION_CLIENT_BUILD = U_Application.version
--- @type string
VERSION = U_Application.version
--- @type boolean
IS_MOBILE_PLATFORM = U_Application.isMobilePlatform
--- @type boolean
IS_EDITOR_PLATFORM = not IS_MOBILE_PLATFORM
--- @type boolean
IS_ANDROID_PLATFORM = PLATFORM == U_RuntimePlatform.Android
--- @type boolean
IS_IOS_PLATFORM = PLATFORM == U_RuntimePlatform.IPhonePlayer
--- @type string
PLATFORM_STRING = IS_IOS_PLATFORM and "iOS" or "Android"
--- @type string
DEVICE_MODEL = U_SystemInfo.deviceModel
--- @type CS_GoogleScript
GOOGLE_SCRIPT = nil
--- @type boolean
LOWER_DEVICE = IS_MOBILE_PLATFORM and U_SystemInfo.SupportsTextureFormat(UnityEngine.TextureFormat.ASTC_RGBA_4x4) == false
---@type string
REMOTE_CONFIG_KEY = "arena_record_noti"
---@type string
REMOTE_CONFIG_ACCOUNT_KEY = "remote_config"
--- @type string
DEVICE_INFO = U_GameUtils.GetDeviceID()

APPSFLYER_ID = function()
    if IS_PREMIUM_VERSION then
        return "1587125912"
    else
        return "1501819108"
    end
end

IOS_STORE_URL_PREFIX = "itms-apps://itunes.apple.com/app/"
ANDROID_STORE_URL_PREFIX = "market://details?id=%s"
APP_IDENTIFIER_GLOBAL = "com.fansipan.summoners.era.idle"

APPSFLYER_ID_GLOBAL = "1501819108"

---@type string
IDENTIFIER_ANDROID_PREMIUM = "com.fansipan.idle.summoners.era.heroes.afk"
---@type string
IDENTIFIER_IOS_PREMIUM = "com.fansipan.idle.summoners.era.heroes.afk.rpg"
--- @type boolean
IS_PREMIUM_VERSION = (U_Application.identifier == IDENTIFIER_ANDROID_PREMIUM) or (U_Application.identifier == IDENTIFIER_IOS_PREMIUM)


