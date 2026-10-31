local function EnabledTracking()
    return zg.isInitTrackingCompleted == true and zgUnity.IsTest == false
end

CampaignTrackingList = {
    205020,
    206025,
    302006,
    303026,
    305011,
    306021,
    306033,
    307038
}

---@class AFInAppEvents
AFInAppEvents = {
    -- Event Type
    SERVER_ID = "af_server_id",
    LEVEL_ACHIEVED = "af_level_achieved",
    DAILY_QUEST = "af_daily_quest",
    ADD_PAYMENT_INFO = "af_add_payment_info",
    ADD_TO_CART = "af_add_to_cart",
    ADD_TO_WISH_LIST = "af_add_to_wishlist",
    COMPLETE_REGISTRATION = "af_complete_registration",
    TUTORIAL_COMPLETION = "af_tutorial_completion",
    INITIATED_CHECKOUT = "af_initiated_checkout",
    PURCHASE = "af_purchase",
    RATE = "af_rate",
    SEARCH = "af_search",
    SPENT_CREDIT = "af_spent_credits",
    ACHIEVEMENT_UNLOCKED = "af_achievement_unlocked",
    CONTENT_VIEW = "af_content_view",
    TRAVEL_BOOKING = "af_travel_booking",
    SHARE = "af_share",
    INVITE = "af_invite",
    LOGIN = "af_login",
    FB_LOGIN = "af_fb_login",
    RE_ENGAGE = "af_re_engage",
    UPDATE = "af_update",
    OPENED_FROM_PUSH_NOTIFICATION = "af_opened_from_push_notification",
    LOCATION_CHANGED = "af_location_changed",
    LOCATION_COORDINATES = "af_location_coordinates",
    ORDER_ID = "af_order_id",
    SESSION = "af_session",
    CAMPAIGN = "af_campaign",
    TOWER = "af_tower",
    DUNGEON = "af_dungeon",
    UNINSTALL = "af_uninstall",
    MEDIATION_AD_COMPLETE = "af_mediation_ad_complete",
    -- Event Parameter Name
    LEVEL = "af_user_level",
    SCORE = "af_score",
    SUCCESS = "af_success",
    PRICE = "af_price",
    CONTENT_TYPE = "af_content_type",
    CONTENT_ID = "af_content_id",
    CONTENT_LIST = "af_content_list",
    CURRENCY = "af_currency",
    QUANTITY = "af_quantity",
    REGISTRATION_METHOD = "af_registration_method",
    PAYMENT_INFO_AVAILABLE = "af_payment_info_available",
    MAX_RATING_VALUE = "af_max_rating_value",
    RATING_VALUE = "af_rating_value",
    SEARCH_STRING = "af_search_string",
    DATE_A = "af_date_a",
    DATE_B = "af_date_b",
    DESTINATION_A = "af_destination_a",
    DESTINATION_B = "af_destination_b",
    DESCRIPTION = "af_description",
    CLASS = "af_class",
    EVENT_START = "af_event_start",
    EVENT_END = "af_event_end",
    LATITUDE = "af_lat",
    LONGTITUDE = "af_long",
    CUSTOMER_USER_ID = "af_customer_user_id",
    VALIDATED = "af_validated",
    REVENUE = "af_revenue",
    RECEIPT_ID = "af_receipt_id",
    COUNT = "af_count",
    STAGE = "af_stage",
    TUTORIAL_ID = "af_tutorial_id",
    TUTORIAL_CONTENT = "af_tutorial_content",
    TRIAL_SUB = "trial_sub"
}

AssetDownloadedStep = {
    Init = "init",
    StartDownloadLuaCsv = "start_download_lua_csv",
    FinishDownloadLuaCsv = "finish_download_lua_csv",
    StartDownloadBundleConfig = "start_download_bundle_config",
    FinishDownloadBundleConfig = "finish_download_bundle_config",
    ShowPopupDownload = "show_popup_download",
    ShowPopupRecommendWifi = "show_popup_recommend_wifi",
    ClosePopupRecommendWifi = "close_popup_recommend_wifi",
    StartDownloadBundle = "start_download_bundle",
    FinishDownloadBundle = "finish_download_bundle",
    ShowFailedGoogleScript = "show_failed_google_script",
    ShowFailedLuaCsv = "show_failed_lua_csv",
    ShowFailedAssetBundleManifest = "show_failed_asset_bundle_manifest",
    ShowFailedAssetBundle = "show_failed_asset_bundle",
    ShowPopupDisconnect = "show_popup_disconnect",
    ClosePopupDisconnect = "close_popup_disconnect",
    ShowPopupNewUpdate = "show_popup_new_update",
    ClosePopupNewUpdate = "close_popup_new_update",
    ShowPopupNotEnoughSpace = "show_popup_not_enough_space",
    ClosePopupNotEnoughSpace = "close_popup_not_enough_space",
    TapToPlay = "tap_to_play"
}

--- @class FBEvents
FBEvents = {
    --- action
    BUTTON_CLICK = "button_click",
    ASSET_DOWNLOADED = "asset_downloaded",
    ASSET_BUNDLE_DOWNLOAD = "asset_bundle_download",
    ---
    STEP = "step",
    CATEGORY = "category",
    NAME = "name",
    ID = "id",
    MAIN_MAP = "main_map",
    MAIN_FEATURES = "main_features",
    DUNGEON = "dungeon",
    GUILD = "guild",
    RAID = "raid",
    CAMPAIGN = "campaign",
    TOWER = "tower",
    FRIEND = "friend",
    BLACK_MARKET = "black_market",
    IAP_SHOP = "iap_shop",
    FIRST_PURCHASE = "first_purchase",
    FLASH_SALE = "flash_sale",
    BUILD_VERSION = "build_version",
    TRIAL_SUB = "trial_sub",
    STARTER_PACK = "starter_pack",
    SERVER_OPEN = "server_open",
    SERVER_WEEK_1 = "server_week1",
    SERVER_WEEK_2 = "server_week2",
    SERVER_WEEK_3 = "server_week3",
    NEW_TUTORIAL = "new_tutorial",
    NEW_RATING = "new_rating",
    EVENT_CHRISTMAS = "event_chrismas",
    EVENT_BOSS_CHALLENGE = "event_boss_challenge",
    EVENT_DRAGON_TOWER = "event_dragon_tower",
    EVENT_PUZZLE = "event_puzzle",
    PURCHASE_CLICK = "purchase_click",
    ZITGA_BATTLE = "zitga_battle",
    ZITGA_HERO = "zitga_hero",
    EARN_RESOURCE = "earn_resource",
    EVENT_NEW_YEAR_2023 = "event_newyear",
    EVENT_QIXI_FESTIVAL = "event_qixi",
    EVENT_BLOSSOM = "event_blossom_day",
    EVENT_LUNAR_NEW_YEAR_2024 = "event_lunar_new_year_2024",
    EVENT_MAY_DAY = "event_may_day",
    EVENT_VALENTINE_2024 = "event_valentine_2024",
    BATTLE_ID = "battle_id",
    STAGE_ID = "stage_id",
    MODE = "mode",
    FACTION_BUFF = "faction_buff",
    SUMMONER_ID = "summoner_id",
    FORMATION = "formation",
    BATTLE_POWER = "battle_power",
    WIN = "win",
    IS_ATTACKER = "is_attacker",
    HERO_ID = "hero_id",
    POSITION = "position",
    FORMATION_ID = "formation_id",
    ITEM_CATEGORY = "item_category",
    ITEM_BRAND = "item_brand",
    ITEM_ID = "item_id",
    VALUE = "value",
    SOURCE = "source",
    SOURCE_ID = "source_id",
    START_ASSET_BUNDLE_DOWNLOAD = "start_asset_bundle_download",
    END_ASSET_BUNDLE_DOWNLOAD = "end_asset_bundle_download"
}

--- @class FBProperties
FBProperties = {
    ONLINE_TIME = "online_time",
    LEVEL = "level",
    SESSION_PLAY = "session_play",
    GEM_ACHIEVE = "gem_achieve",
    GEM_SPEND = "gem_spend",
    GOLD_ACHIEVE = "gold_achieve",
    GOLD_SPEND = "gold_spend",
    HERO_ACHIEVE = "hero_achieve",
    VIP_POINT = "vip_point",
    VIP = "vip",
    STAGE = "stage",
    IAP_COUNT = "iap_count",
    NUMBER_DAY_PLAY = "number_day_play",
    SERVER_ID = "server_id",
    PLAYER_ID = "player_id",
    REWARDED_VIDEO_COUNT = "rewarded_video_count",
    APPSFLYER_ID = "appsflyer_id",
    STEP = "step",
    IS_SKIP_TUTORIAL = "is_skip_tutorial",
    CAMPAIGN_ID = "campaign_id",
    IS_WIN = "is_win",
    LIKE_BUTTON_CLICK = "like_button_click",
    RATE_BUTTON_CLICK = "rate_button_click"
}

--- @class AdsPlacement
AdsPlacement = {
    EVENT_ZODIAC_BUNDLE = "Event_Zodiac_Bundle",
    EVENT_AIRYUU_BUNDLE = "Event_Airyuu_Bundle",
    EVENT_TOWER_OF_EITRI_BUNDLE = "Event_Tower_Of_Eitri_Bundle",
    EVENT_MID_AUTUMN_BUNDLE = "Event_Mid_Autumn_Bundle",
    EVENT_BOSS_CHALLENGE_BUNDLE = "Event_Boss_Challenge_Bundle",
    EVENT_SEASONAL_BUNDLE = "Event_Seasonal_Bundle",
    HAND_MIDAS = "Hand_Midas",
    SHOP_DAILY_BUNDLE = "Shop_Daily_Bundle",
    SHOP_WEEKLY_BUNDLE = "Shop_Weekly_Bundle",
    SHOP_MONTHLY_BUNDLE = "Shop_Monthly_Bundle",
    QUICK_BATTLE = "Quick_Battle",
    DAILY_GEM_POPUP = "Daily_Gem_Popup",
    EVENT_BUY_LEVEL = "event_buy_level",
    RAID_KEY_ADS = "Raid_Key",
    PREMIUM_SUMMON = "Premium_Summon",
    FORTUNE_WHEEL = "Fortune_Wheel",
}

--- @class TrackingUtils
TrackingUtils = {
    --- @type number
    session = 0,
    --- @type TrackingInBound
    server = nil
}

local firebaseEventList = List()

--- @param eventName string
function TrackingUtils.AddAppsflyerEvent(eventName, ...)
    local dict = CS.System.Collections.Generic.Dictionary(CS.System.String, CS.System.String)
    local args = { ... }
    if #args % 2 == 0 then
        local purchaseEvent = dict()
        if PlayerSettingData.serverId ~= nil then
            purchaseEvent:Add(AFInAppEvents.SERVER_ID, PlayerSettingData.serverId)
        end
        for i = 1, #args, 2 do
            purchaseEvent:Add(args[i], args[i + 1])
        end
        if EnabledTracking() then
            Coroutine.start(function()
                zgUnity.appsflyer:TrackingEvent(eventName, purchaseEvent)
            end)
        else
            --XDebug.Log(string.format("APPSFLYER TRACKING:event[ % s] args[%s]]", eventName, LogUtils.ToDetail(args)))
        end
    else
        XDebug.Error("Data input is not valid:" .. LogUtils.ToDetail(args))
    end
end

--- @param step number
function TrackingUtils.TrackingTutorial(_category, _name, _id)
    TrackingUtils.AddFirebaseEvent(FBEvents.NEW_TUTORIAL, _category, _name, _id)
end

--- @param step number
function TrackingUtils.TrackingRating(_category, _name, _id)
    TrackingUtils.AddFirebaseEvent(FBEvents.NEW_RATING, _category, _name, _id)
end


--- @param step number
function TrackingUtils.TrackingCampaign(_category, _name, _id)
    TrackingUtils.AddFirebaseEvent(FBEvents.CAMPAIGN, _category, _name, _id)
end

function TrackingUtils.AddFireBaseClickButtonEvent(_category, _name, _id)
    TrackingUtils.AddFirebaseEvent(FBEvents.BUTTON_CLICK, _category, _name, _id)
end

function TrackingUtils.AddFireBasePurchaseClickEvent(_category, _name, _id)
    TrackingUtils.AddFirebaseEvent(FBEvents.PURCHASE_CLICK, _category, _name, _id)
end

function TrackingUtils.AddFireBaseAssetBundleDownloadEvent(_category, _name, _id)
    if _name == nil then
        _name = ""
    end
    TrackingUtils.AddFirebaseEvent(FBEvents.ASSET_BUNDLE_DOWNLOAD, _category, _name, _id)
end

function TrackingUtils.AddFireBaseClickMainArea(_category, _name, _id)
    Coroutine.start(function()
        coroutine.waitforseconds(4)
        TrackingUtils.AddFirebaseEvent(FBEvents.BUTTON_CLICK, _category, _name, _id)
    end)
end

--- @param eventName string
function TrackingUtils.AddMkt(eventName)
    TrackingUtils.AddAppsflyerEvent(eventName)
    TrackingUtils.AddFirebaseEvent(eventName, FBProperties.SERVER_ID, PlayerSettingData.serverId)
end

function TrackingUtils.AddFirebaseEventWithArgs(_event, ...)
    --if IS_MOBILE_PLATFORM then
    --    local args = { ... }
    --    local content = ""
    --    for i = 1, #args do
    --        if i == #args then
    --            content = content .. tostring(args[i])
    --        else
    --            content = content .. tostring(args[i]) .. "|"
    --        end
    --    end
    --    if zg.isInitTrackingCompleted == true then
    --        Coroutine.start(function()
    --            zgUnity.firebase:SetUserEventWithArgs(_event, content)
    --        end)
    --    else
    --        local data = {}
    --        data.event = _event
    --        data.content = content
    --        firebaseEventList:Add(data)
    --    end
    --else
    --    --XDebug.Log(string.format("EDITOR FIREBASE TRACKING:event[%s] category[%s] name[%s]]", _event, _category, _name))
    --end
end

function TrackingUtils.AddFirebaseEvent(_event, _category, _name, _id)
    --if IS_MOBILE_PLATFORM then
    --    --assert(_category and _name)
    --    --local content
    --    --if _id ~= nil then
    --    --    content = string.format("%s|%s|%s", _category, _name, _id)
    --    --else
    --    --    content = string.format("%s|%s", _category, _name)
    --    --end
    --    --if zg.isInitTrackingCompleted == true then
    --    --    Coroutine.start(function()
    --    --        zgUnity.firebase:SetUserEvent(_event, content)
    --    --    end)
    --    --else
    --    --    local data = {}
    --    --    data.event = _event
    --    --    data.content = content
    --    --    firebaseEventList:Add(data)
    --    --end
    --else
    --    --XDebug.Log(string.format("EDITOR FIREBASE TRACKING:event[%s] category[%s] name[%s]]", _event, _category, _name))
    --end
end

--- @param category string
--- @param name string
--- @param id string
function TrackingUtils.AddFirebaseAssetDownloaded(category, name, id)
    if name == nil then
        name = ""
    end
    TrackingUtils.AddFirebaseEvent(FBEvents.ASSET_DOWNLOADED, category, name, id)
end

function TrackingUtils.AddFirebasePendingEvent()
    --if firebaseEventList:Count() > 0 then
    --    XDebug.Log(string.format("FB pending event:%d", firebaseEventList:Count()))
    --    for i, v in ipairs(firebaseEventList:GetItems()) do
    --        Coroutine.start(function()
    --            zgUnity.firebase:SetUserEvent(v.event, v.content)
    --        end)
    --    end
    --    firebaseEventList:Clear()
    --end
end

--- @param method PlayerDataMethod
function TrackingUtils.AddClickLeaderBoardEvent(method)
    local category
    if method == LeaderBoardType.DUNGEON then
        category = FBEvents.DUNGEON
    elseif method == LeaderBoardType.CAMPAIGN then
        category = FBEvents.CAMPAIGN
    elseif method == LeaderBoardType.TOWER then
        category = FBEvents.TOWER
    elseif method == LeaderBoardType.FRIEND_RANKING then
        category = FBEvents.FRIEND
    end
    if category ~= nil then
        TrackingUtils.AddFireBaseClickButtonEvent(category, "leaderboard")
    end
end

function TrackingUtils.AddFirebaseProperty(name, property)
    --XDebug.Log(string.format("FireBase[Name:%s, Property:%s]", name, property))
    if property == 0 then
        XDebug.Warning(string.format("Property is Zero:%s", name))
        return
    end
    if EnabledTracking() then
        if zgUnity.firebase ~= nil then
            Coroutine.start(function()
                zgUnity.firebase:SetUserProperty(name, tostring(property))
            end)
        end
    end
end

function TrackingUtils.SetSession()
    TrackingUtils.session = U_PlayerPrefs.GetInt(PlayerPrefsKey.AF_SESSION, 0)
    TrackingUtils.session = TrackingUtils.session + 1
    TrackingUtils.AddAppsflyerEvent(AFInAppEvents.SESSION, AFInAppEvents.COUNT, tostring(TrackingUtils.session))
    TrackingUtils.AddFirebaseProperty(FBProperties.SESSION_PLAY, TrackingUtils.session)
    U_PlayerPrefs.SetInt(PlayerPrefsKey.AF_SESSION, TrackingUtils.session)
end

function TrackingUtils.SetAppsflyerIdForFirebase()
    if EnabledTracking() then
        TrackingUtils.AddFirebaseProperty(FBProperties.APPSFLYER_ID, zgUnity.appsflyer:GetAppsflyerId())
    end
end

function TrackingUtils.CompleteTutorial()
    TrackingUtils.AddAppsflyerEvent(AFInAppEvents.TUTORIAL_COMPLETION, AFInAppEvents.SUCCESS, tostring(true))
end

--- @param level number
function TrackingUtils.SetSummonerLevel(level)
    --XDebug.Log(string.format("level = %s, result = %s", tostring(level), tostring(ResourceMgr.GetTrackingConfig():IsContainLevel(level))))
    if ResourceMgr.GetTrackingConfig():IsContainLevel(level) then
        --XDebug.Log(string.format("Tracking event:%s[%d]", AFInAppEvents.LEVEL_ACHIEVED, level))
        TrackingUtils.AddAppsflyerEvent(AFInAppEvents.LEVEL_ACHIEVED, AFInAppEvents.LEVEL, tostring(level))
    end
    TrackingUtils.AddFirebaseProperty(FBProperties.LEVEL, level)
end

function TrackingUtils.SetMediationAds()
    TrackingUtils.AddAppsflyerEvent(AFInAppEvents.MEDIATION_AD_COMPLETE, AFInAppEvents.SUCCESS, tostring(true))
end

--- @param eventName AFInAppEvents CAMPAIGN|TOWER|DUNGEON
--- @param stageId number
function TrackingUtils.SetStage(eventName, stageId)
    TrackingUtils.AddAppsflyerEvent(eventName, AFInAppEvents.STAGE, tostring(stageId))
    if eventName == AFInAppEvents.CAMPAIGN then
        if ResourceMgr.GetTrackingConfig():IsContainPVE(stageId) then
            assert(stageId and PlayerSettingData.serverId)
            local event = string.format("pass_%d", stageId)
            --XDebug.Log("Tracking event:" .. event)
            TrackingUtils.AddAppsflyerEvent(event)
            TrackingUtils.AddFirebaseEvent(event, FBProperties.SERVER_ID, PlayerSettingData.serverId)
        end
    end
end

function TrackingUtils.SetTrialSubscription()
    assert(PlayerSettingData.serverId)
    --XDebug.Log("Tracking event:" .. AFInAppEvents.TRIAL_SUB)
    TrackingUtils.AddAppsflyerEvent(AFInAppEvents.TRIAL_SUB)
    TrackingUtils.AddFirebaseEvent(AFInAppEvents.TRIAL_SUB, FBProperties.SERVER_ID, PlayerSettingData.serverId)
end

--- @param authMethod AuthMethod
function TrackingUtils.Login(authMethod)

    local eventName = authMethod == AuthMethod.LOGIN_BY_FACEBOOK and AFInAppEvents.FB_LOGIN or AFInAppEvents.LOGIN
    TrackingUtils.AddAppsflyerEvent(eventName, AFInAppEvents.SUCCESS, tostring(true))
end

--- don't use now
--- @param userId string
function TrackingUtils.SetUserId(userId)
    if EnabledTracking() then
        Coroutine.start(function()
            zgUnity.firebase:SetUserId(userId)
        end)
    end
end

--- @return BehaviorSubject
function TrackingUtils.RequestProperty()
    local subject = Subject.Create()
    TrackingUtils.server = nil
    require("lua.client.core.network.tracking.TrackingInBound")
    NetworkUtils.RequestAndCallback(OpCode.TRACKING_INFO_GET, nil, nil, nil, function(buffer)
        subject:Next()
        TrackingUtils.server = TrackingInBound(buffer)
        TrackingUtils.SetSession()
        TrackingUtils.SetAppsflyerIdForFirebase()
    end)
    return subject
end

--- @param iapReceipt IAPReceipt
function TrackingUtils.SetPurchase(iapReceipt)
    XDebug.Log(">> TrackingUtils ", LogUtils.ToDetail(iapReceipt))
    TrackingUtils.AddAppsflyerEvent(AFInAppEvents.PURCHASE,
            AFInAppEvents.CURRENCY, iapReceipt.isoCurrencyCode,
            AFInAppEvents.REVENUE, tostring(iapReceipt.localizedPrice),
            AFInAppEvents.QUANTITY, "1",
            AFInAppEvents.CONTENT_ID, iapReceipt.pack_name,
            AFInAppEvents.ORDER_ID, iapReceipt.transaction_id,
            AFInAppEvents.RECEIPT_ID, iapReceipt.transaction_id
    )

    local packSplits = iapReceipt.pack_name:Split('.')
    local packId = packSplits[#packSplits]
    if ResourceMgr.GetTrackingConfig():IsContainPack(packId) then
        local event = string.format("pay_%s", packId)
        --XDebug.Log("Tracking event:" .. event)
        TrackingUtils.AddAppsflyerEvent(event)
        TrackingUtils.AddFirebaseEvent(event, FBProperties.SERVER_ID, PlayerSettingData.serverId)
    end
end
