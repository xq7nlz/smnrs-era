require "lua.client.data.Purchase.ProductConfig"
require "lua.client.data.Purchase.SaleOffProductConfig"
require "lua.client.data.Purchase.GroupProductConfig"
require "lua.client.data.Purchase.MidAutumnProductConfig"
require "lua.client.data.Purchase.PackOfProducts"
require "lua.client.data.Purchase.PackOfSaleProducts"
require "lua.client.data.Purchase.PurchaseStore"
require "lua.client.data.Purchase.CashShop.CashShop"
require "lua.client.data.Purchase.Event.BundleStore"
require "lua.client.data.Purchase.Event.HotDealStore"
require "lua.client.data.Purchase.Event.SaleOffStore"
require "lua.client.data.Purchase.Event.EventArenaPassStore"
require "lua.client.data.Purchase.Event.EventDailyQuestPassStore"
require "lua.client.data.RewardSet.RewardRequirePriceConfig"
require "lua.client.data.Purchase.MidAutumn.MidAutumnStore"
require "lua.client.data.Purchase.Halloween.HalloweenStore"
require "lua.client.data.Purchase.Halloween.HalloweenDailyStore"
require "lua.client.data.Purchase.BlackFriday.BlackFridayCardStore"
require "lua.client.data.Purchase.BlackFriday.BlackFridayGemPackStore"
require "lua.client.data.Purchase.Xmas.XmasExclusiveStore"
require "lua.client.data.Purchase.Xmas.XmasDailyStore"
require "lua.client.data.Purchase.NewYear.NewYearCardStore"
require "lua.client.data.Purchase.NewYear.NewYearBundleStore"
require "lua.client.data.Purchase.LunarNewYear.LunarPathStore"
require "lua.client.data.Purchase.LunarNewYear.EliteBundleStore"
require "lua.client.data.Purchase.LunarNewYear.LunarSkinBundle"
require "lua.client.data.Purchase.LunarNewYear.LunarExclusiveStore"
require "lua.client.data.Purchase.LunarNewYear.TigerPathStore"
require "lua.client.data.Purchase.Birthday.LegacyPathStore"
require "lua.client.data.Purchase.LoveBundleStore"
require "lua.client.data.Purchase.EventReleaseKazetsu.KazetsuBundleStore"
require "lua.client.data.Purchase.NewHeroBundle.NewHeroBundleStore"
require "lua.client.data.Purchase.MergeServer.MergeServerStore"
require "lua.client.data.Purchase.EasterEgg.EasterBunnyCardStore"
require "lua.client.data.Purchase.EasterEgg.EasterDailyBundleStore"
require "lua.client.data.Purchase.EasterEgg.EasterSkinBundleStore"
require "lua.client.data.Purchase.EventSkinHotDeal.EventSkinHotDealStore"
require "lua.client.data.Purchase.NewHeroSkinBundle.NewHeroSkinBundleStore"
require "lua.client.data.Purchase.EventSkinBundle.SkinBundleStore"
require "lua.client.data.Purchase.Birthday.BirthdayBundleStore"
require "lua.client.data.Purchase.Birthday.BirthdayExclusiveBundleStore"
require "lua.client.data.Purchase.Birthday.EventBirthdayPurchaseLevelStore"
require "lua.client.data.Purchase.Zodiac.ZodiacBundleStore"
require "lua.client.data.Purchase.LunarNewYear.LunarSpringBundleStore"
require "lua.client.data.Purchase.HeroRelease.HeroReleaseStore"
require "lua.client.data.Purchase.BattlePass.BattlePassBundleLevelStore"
require "lua.client.data.Purchase.BattlePass.BattlePassBundlePremiumTicketStore"
require "lua.client.data.Purchase.ServerWeekBundle.ServerWeekBundleStore"
require "lua.client.data.Purchase.BlackFriday.BlackFridayBundleStore"
require "lua.client.data.Purchase.ServerWeekBundle.ServerWeekBundle2Store"
require "lua.client.data.Purchase.ServerWeekBundle.ServerWeekBundle3Store"
require "lua.client.data.Purchase.IdleEffect.IdleEffectBundleStore"
require "lua.client.data.Purchase.IdleEffect.RandomIdleEffectBundleStore"
require "lua.client.data.Purchase.EventSkinChallenge.SkinChallengeBundleStore"
require "lua.client.data.Purchase.EventAiryuu.EventAiryuuBundleStore"
require "lua.client.data.Purchase.EventTowerOfEitri.EventTowerOfEitriBundleStore"
require "lua.client.data.Purchase.EventBossChallenge.EventBossChallengeBundleStore"
require "lua.client.data.Purchase.EventSeasonal.EventSeasonalBundleStore"
require "lua.client.data.Purchase.EventPieceAdventure.EventPieceAdventureBundleStore"
require "lua.client.data.Purchase.EventBlackFridayNewVersion.EventBlackFridayNewBundleStore"
require "lua.client.data.Purchase.EventThanksGiving.ThanksGivingStore"
require "lua.client.data.Purchase.EventThanksGiving.ThanksGivingDailyStore"
require "lua.client.data.Purchase.Christmas.ChristmasStore"
require "lua.client.data.Purchase.EventNewYear2023.NewYear2023Store"
require "lua.client.data.Purchase.EventNewYear2023.NewYear2023DailyStore"
require "lua.client.data.Purchase.EventLunarNewYear2024.LunarNewYear2024Store"
require "lua.client.data.Purchase.EventValentine2024.Valentine2024Store"
require "lua.client.data.Purchase.EventEasterDay.EasterDayStore"
require "lua.client.data.Purchase.EventEasterDay.EasterDayDailyStore"
require "lua.client.data.Purchase.EventSummerDay.SummerDayStore"
require "lua.client.data.Purchase.EventSummerDay.SummerDayDailyStore"
require "lua.client.data.Purchase.EventBlossomDay.BlossomDayStore"
require "lua.client.data.Purchase.EventBlossomDay.BlossomDayDailyStore"
require "lua.client.data.Purchase.EventQixiFestival.QixiFestivalStore"
require "lua.client.data.Purchase.EventQixiFestival.QixiFestivalDailyStore"
require "lua.client.data.Purchase.EventMayDay.MayDayStore"


local EVENT_PURCHASE_CONFIG_PATH = "csv/client/event_purchase.csv"
local CAMPAIGN_STAGE_OPEN_TRIAL_MONTHLY = "csv/client/open_trial_monthly_by_campaign_stage.csv"
local FIRST_TIME_REWARD_PATH = "csv/purchase/first_time_reward.csv"
local FIRST_TIME_REWARD_AB_TEST_PATH = "csv/purchase/first_time_reward_ab_test/data_%s/first_time_reward.csv"

--- @class PurchaseConfig
PurchaseConfig = Class(PurchaseConfig)

function PurchaseConfig:Ctor()
    --- @type CashShop
    self.cashShop = nil
    --- @type HotDealStore
    self.hotDeal = nil
    --- @type BundleStore
    self.bundle = nil
    --- @type SaleOffStore
    self.saleOff = nil
    --- @type EventArenaPassStore
    self.eventArenaPassStore = nil
    --- @type EventDailyQuestPassStore
    self.eventDailyQuestPassStore = nil
    --- @type MidAutumnStore
    self.eventMidAutumnStore = nil
    --- @type ChristmasStore
    self.eventChristmasStore = nil
    --- @type HalloweenStore
    self.eventHalloweenStore = nil
    --- @type LunarPathStore
    self.eventLunarPathStore = nil
    --- @type LunarExclusiveStore
    self.eventLunarExclusiveStore = nil
    --- @type LunarSpringBundleStore
    self.eventLunarSpringBundleStore = nil
    --- @type TigerPathStore
    self.eventLunarTigerPathStore = nil
    --- @type LegacyPathStore
    self.eventLegacyPathStore = nil
    --- @type EasterBunnyCardStore
    self.eventEasterBunnyCardStore = nil
    --- @type EasterDailyBundleStore
    self.eventEasterDailyBundleStore = nil
    --- @type EasterSkinBundleStore
    self.eventEasterSkinBundleStore = nil
    --- @type NewHeroSkinBundleStore
    self.newHeroSkinBundleStore = nil
    --- @type SkinBundleStore
    self.skinBundleStore = nil
    --- @type BirthdayBundleStore
    self.eventBirthdayBundleStore = nil
    --- @type BirthdayExclusiveBundleStore
    self.eventBirthdayExclusiveBundleStore = nil
    --- @type EventBirthdayPurchaseLevelStore
    self.eventBirthdayPurchaseLevelStore = nil
    --- @type ZodiacBundleStore
    self.eventZodiacBundleStore = nil
    --- @type BattlePassBundleLevelStore
    self.battlePassBundleLevelStore = nil
    --- @type BattlePassBundlePremiumTicketStore
    self.battlePassBundlePremiumTicketStore = nil
    --- @type SkinChallengeBundleStore
    self.eventSkinChallengeBundleStore = nil
    --- @type EventAiryuuBundleStore
    self.eventAiryuuBundleStore = nil
    --- @type EventTowerOfEitriBundleStore
    self.eventTowerOfEitriBundleStore = nil
    --- @type EventBossChallengeBundleStore
    self.eventBossChallengeBundleStore = nil
    --- @type EventSeasonalBundleStore
    self.eventSeasonalBundleStore = nil
    --- @type EventPieceAdventureBundleStore
    self.eventPieceAdventureBundleStore = nil
    --- @type EventBlackFridayNewBundleStore
    self.eventBlackFridayNewBundleStore = nil
    --- @type ThanksGivingStore
    self.eventThanksGivingStore = nil
    --- @type NewYear2023Store
    self.eventNewYear2023BundleStore = nil
    --- @type NewYear2023DailyStore
    self.eventNewYear2023DailyStore = nil
    --- @type LunarNewYear2024Store
    self.eventLunarNewYear2024BundleStore = nil
    --- @type Valentine2024Store
    self.eventValentine2024BundleStore = nil
    --- @type EasterDayStore
    self.eventEasterDayBundleStore = nil
    --- @type BlossomDayStore
    self.eventBlossomDayBundleStore = nil
    --- @type BlossomDayDailyStore
    self.eventBlossomDayDailyStore = nil
    --- @type QixiFestivalStore
    self.eventQixiFestivalBundleStore = nil
    --- @type QixiFestivalDailyStore
    self.eventQixiFestivalDailyStore = nil
    --- @type MayDayStore
    self.eventMayDayBundleStore = nil
    --- @type Dictionary
    self.packBaseConfigDict = nil
    --- @type List
    self.listOpenDayTrialMonthly = nil
    --- @type Dictionary RewardRequirePriceConfig
    self.dicFirstTimeReward = nil

    self:InitCashShop()
    self:InitEvent()
    self:InitPackBase()
end

function PurchaseConfig:InitCashShop()
    self.cashShop = CashShop()
    self.cashShop:InitPack()
    self.cashShop:InitProgressPack()
    self.cashShop:SetKey()
end

function PurchaseConfig:InitEvent()
    local eventConfig = self:GetEventPurchaseConfig()
    --self.hotDeal = HotDealStore()
    --self.hotDeal:InitPack(eventConfig:Get("hot_deal"))
    --self.hotDeal:SetKey()

    self.bundle = BundleStore()
    self.bundle:InitPack(eventConfig:Get("bundle"))
    self.bundle:SetKey()

    self.saleOff = SaleOffStore()
    self.saleOff:InitPack(eventConfig:Get("sale_off"))
    self.saleOff:SetKey()

    self.eventArenaPassStore = EventArenaPassStore()
    self.eventArenaPassStore:InitPack(eventConfig:Get("arena_pass"))
    self.eventArenaPassStore:SetKey()

    self.eventDailyQuestPassStore = EventDailyQuestPassStore()
    self.eventDailyQuestPassStore:InitPack(eventConfig:Get("daily_quest_pass"))
    self.eventDailyQuestPassStore:SetKey()

    self.eventMidAutumnStore = MidAutumnStore()
    self.eventMidAutumnStore:InitPack(eventConfig:Get("mid_autumn"))
    self.eventMidAutumnStore:SetKey()

    self.eventChristmasStore = ChristmasStore()
    self.eventChristmasStore:InitPack(eventConfig:Get("christmas_2023"))
    self.eventChristmasStore:SetKey()

    self.eventHalloweenStore = HalloweenStore()
    self.eventHalloweenStore:InitPack(eventConfig:Get("halloween"))
    self.eventHalloweenStore:SetKey()

    self.eventHalloweenDailyStore = HalloweenDailyStore()
    self.eventHalloweenDailyStore:InitPack(eventConfig:Get("halloween"))
    self.eventHalloweenDailyStore:SetKey()

    self.eventXmasDailyStore = XmasDailyStore()
    self.eventXmasDailyStore:InitPack(eventConfig:Get("christmas"))
    self.eventXmasDailyStore:SetKey()

    self.eventBlackFridayCardStore = BlackFridayCardStore()
    self.eventBlackFridayCardStore:InitPack(eventConfig:Get("black_friday"))
    self.eventBlackFridayCardStore:SetKey()

    self.eventXmasStore = XmasExclusiveStore()
    self.eventXmasStore:InitPack(eventConfig:Get("christmas"))
    self.eventXmasStore:SetKey()

    self.eventNewYearStore = NewYearCardStore()
    self.eventNewYearStore:InitPack(eventConfig:Get("new_year"))
    self.eventNewYearStore:SetKey()

    self.eventNewYearBundleStore = NewYearBundleStore()
    self.eventNewYearBundleStore:InitPack(eventConfig:Get("new_year"))
    self.eventNewYearBundleStore:SetKey()

    self.eventLunarPathStore = LunarPathStore()
    self.eventLunarPathStore:InitPack(eventConfig:Get("lunar_new_year"))
    self.eventLunarPathStore:SetKey()

    self.eventLunarExclusiveStore = LunarExclusiveStore()
    self.eventLunarExclusiveStore:InitPack(eventConfig:Get("lunar_new_year_2022"))
    self.eventLunarExclusiveStore:SetKey()

    self.eventLunarSpringBundleStore = LunarSpringBundleStore()
    self.eventLunarSpringBundleStore:InitPack(eventConfig:Get("lunar_new_year_2022"))
    self.eventLunarSpringBundleStore:SetKey()

    self.eventLunarTigerPathStore = TigerPathStore()
    self.eventLunarTigerPathStore:InitPack(eventConfig:Get("lunar_new_year_2022"))
    self.eventLunarTigerPathStore:SetKey()

    self.eventLegacyPathStore = LegacyPathStore()
    self.eventLegacyPathStore:InitPack(eventConfig:Get("birthday"))
    self.eventLegacyPathStore:SetKey()

    self.eventEliteBundleStore = EliteBundleStore()
    self.eventEliteBundleStore:InitPack(eventConfig:Get("lunar_new_year"))
    self.eventEliteBundleStore:SetKey()

    self.eventLoveBundleStore = LoveBundleStore()
    self.eventLoveBundleStore:InitPack(eventConfig:Get("valentine"))
    self.eventLoveBundleStore:SetKey()

    self.eventKazetsuBundleStore = KazetsuBundleStore()
    self.eventKazetsuBundleStore:InitPack(eventConfig:Get("kazetsu"))
    self.eventKazetsuBundleStore:SetKey()

    self.lunarSkinBundle = LunarSkinBundle()
    self.lunarSkinBundle:InitPack(eventConfig:Get("lunar_new_year"))
    self.lunarSkinBundle:SetKey()

    self.eventNewHeroBundle = NewHeroBundleStore()
    --print(LogUtils.ToDetail(eventConfig:Get("new_hero_bundle")))
    self.eventNewHeroBundle:InitPack(eventConfig:Get("new_hero_bundle"))
    self.eventNewHeroBundle:SetKey()

    self.eventMergeServerStore = MergeServerStore()
    self.eventMergeServerStore:InitPack(eventConfig:Get("server_merge"))
    self.eventMergeServerStore:SetKey()

    self.eventEasterBunnyCardStore = EasterBunnyCardStore()
    self.eventEasterBunnyCardStore:InitPack(eventConfig:Get("easter"))
    self.eventEasterBunnyCardStore:SetKey()

    self.eventEasterDailyBundleStore = EasterDailyBundleStore()
    self.eventEasterDailyBundleStore:InitPack(eventConfig:Get("easter"))
    self.eventEasterDailyBundleStore:SetKey()

    self.eventEasterSkinBundleStore = EasterSkinBundleStore()
    self.eventEasterSkinBundleStore:InitPack(eventConfig:Get("easter"))
    self.eventEasterSkinBundleStore:SetKey()

    self.newHeroSkinBundleStore = NewHeroSkinBundleStore()
    self.newHeroSkinBundleStore:InitPack(eventConfig:Get("new_hero_skin_bundle"))
    self.newHeroSkinBundleStore:SetKey()

    self.skinBundleStore = SkinBundleStore()
    self.skinBundleStore:InitPack(eventConfig:Get("skin_bundle"))
    self.skinBundleStore:SetKey()

    self.eventBirthdayBundleStore = BirthdayBundleStore()
    self.eventBirthdayBundleStore:InitPack(eventConfig:Get("birthday"))
    self.eventBirthdayBundleStore:SetKey()

    self.eventBirthdayExclusiveBundleStore = BirthdayExclusiveBundleStore()
    self.eventBirthdayExclusiveBundleStore:InitPack(eventConfig:Get("birthday"))
    self.eventBirthdayExclusiveBundleStore:SetKey()

    self.eventBirthdayPurchaseLevelStore = EventBirthdayPurchaseLevelStore()
    self.eventBirthdayPurchaseLevelStore:InitPack(eventConfig:Get("birthday"))
    self.eventBirthdayPurchaseLevelStore:SetKey()

    self.eventZodiacBundleStore = ZodiacBundleStore()
    self.eventZodiacBundleStore:InitPack(eventConfig:Get("zodiac"))
    self.eventZodiacBundleStore:SetKey()

    self.eventHeroReleaseStore = HeroReleaseStore()
    self.eventHeroReleaseStore:InitPack(eventConfig:Get("new_hero_release"))
    self.eventHeroReleaseStore:SetKey()

    self.battlePassBundleLevelStore = BattlePassBundleLevelStore()
    self.battlePassBundleLevelStore:InitPack(eventConfig:Get("battle_pass"))
    self.battlePassBundleLevelStore:SetKey()

    self.battlePassBundlePremiumTicketStore = BattlePassBundlePremiumTicketStore()
    self.battlePassBundlePremiumTicketStore:InitPack(eventConfig:Get("battle_pass"))
    self.battlePassBundlePremiumTicketStore:SetKey()

    ---@type ServerWeekBundle3Store
    self.serverWeekBundle3Store = ServerWeekBundle3Store()
    self.serverWeekBundle3Store:InitPack(eventConfig:Get("server_open_3"))
    self.serverWeekBundle3Store:SetKey()

    ---@type ServerWeekBundle2Store
    self.serverWeekBundle2Store = ServerWeekBundle2Store()
    self.serverWeekBundle2Store:InitPack(eventConfig:Get("server_open_2"))
    self.serverWeekBundle2Store:SetKey()

    ---@type ServerWeekBundleStore
    self.serverWeekBundleStore = ServerWeekBundleStore()
    self.serverWeekBundleStore:InitPack(eventConfig:Get("server_open"))
    self.serverWeekBundleStore:SetKey()

    ---@type IdleEffectBundleStore
    self.idleEffectBundleStore = IdleEffectBundleStore()
    self.idleEffectBundleStore:InitPack(eventConfig:Get("idle_effect_bundle"))
    self.idleEffectBundleStore:SetKey()

    ---@type RandomIdleEffectBundleStore
    self.randomIdleEffectBundleStore = RandomIdleEffectBundleStore()
    self.randomIdleEffectBundleStore:InitPack(eventConfig:Get("idle_effect_bundle"))
    self.randomIdleEffectBundleStore:SetKey()

    ---@type BlackFridayBundleStore
    self.eventBlackFridayBundleStore = BlackFridayBundleStore()
    self.eventBlackFridayBundleStore:InitPack(eventConfig:Get("black_friday"))
    self.eventBlackFridayBundleStore:SetKey()

    ---@type EventSkinHotDealStore
    self.eventSkinHotDealBundleStore = EventSkinHotDealStore()
    self.eventSkinHotDealBundleStore:InitPack(eventConfig:Get("skin_hot_deal"))
    self.eventSkinHotDealBundleStore:SetKey()

    ---@type SkinChallengeBundleStore
    self.eventSkinChallengeBundleStore = SkinChallengeBundleStore()
    self.eventSkinChallengeBundleStore:InitPack(eventConfig:Get("skin_challenge"))
    self.eventSkinChallengeBundleStore:SetKey()

    ---@type EventAiryuuBundleStore
    self.eventAiryuuBundleStore = EventAiryuuBundleStore()
    self.eventAiryuuBundleStore:InitPack(eventConfig:Get("hero_airyuu"))
    self.eventAiryuuBundleStore:SetKey()

    ---@type EventTowerOfEitriBundleStore
    self.eventTowerOfEitriBundleStore = EventTowerOfEitriBundleStore()
    self.eventTowerOfEitriBundleStore:InitPack(eventConfig:Get("dragon_tower"))
    self.eventTowerOfEitriBundleStore:SetKey()

    ---@type EventBossChallengeBundleStore
    self.eventBossChallengeBundleStore = EventBossChallengeBundleStore()
    self.eventBossChallengeBundleStore:InitPack(eventConfig:Get("boss_challenge"))
    self.eventBossChallengeBundleStore:SetKey()

    ---@type EventSeasonalBundleStore
    self.eventSeasonalBundleStore = EventSeasonalBundleStore()
    self.eventSeasonalBundleStore:InitPack(eventConfig:Get("seasonal"))
    self.eventSeasonalBundleStore:SetKey()

    ---@type EventPieceAdventureBundleStore
    self.eventPieceAdventureBundleStore = EventPieceAdventureBundleStore()
    self.eventPieceAdventureBundleStore:InitPack(eventConfig:Get("piece_adventure"))
    self.eventPieceAdventureBundleStore:SetKey()

    ---@type EventBlackFridayNewBundleStore
    self.eventBlackFridayNewBundleStore = EventBlackFridayNewBundleStore()
    self.eventBlackFridayNewBundleStore:InitPack(eventConfig:Get("black_friday_sale"))
    self.eventBlackFridayNewBundleStore:SetKey()

    ---@type EventBlackFridayNewBundleStore
    self.eventThanksGivingBundleStore = ThanksGivingStore()
    self.eventThanksGivingBundleStore:InitPack(eventConfig:Get("thanks_giving"))
    self.eventThanksGivingBundleStore:SetKey()

    self.eventThanksGivingDailyStore = ThanksGivingDailyStore()
    self.eventThanksGivingDailyStore:InitPack(eventConfig:Get("thanks_giving"))
    self.eventThanksGivingDailyStore:SetKey()

    ---@type NewYear2023Store
    self.eventNewYear2023BundleStore = NewYear2023Store()
    self.eventNewYear2023BundleStore:InitPack(eventConfig:Get("new_year_2023"))
    self.eventNewYear2023BundleStore:SetKey()

    ---@type NewYear2023DailyStore
    self.eventNewYear2023DailyStore = NewYear2023DailyStore()
    self.eventNewYear2023DailyStore:InitPack(eventConfig:Get("new_year_2023"))
    self.eventNewYear2023DailyStore:SetKey()

    ---@type LunarNewYear2024Store
    self.eventLunarNewYear2024BundleStore = LunarNewYear2024Store()
    self.eventLunarNewYear2024BundleStore:InitPack(eventConfig:Get("lunar_new_year_2024"))
    self.eventLunarNewYear2024BundleStore:SetKey()

    ---@type Valentine2024Store
    self.eventValentine2024BundleStore = Valentine2024Store()
    self.eventValentine2024BundleStore:InitPack(eventConfig:Get("valentine_2024"))
    self.eventValentine2024BundleStore:SetKey()

    ---@type EasterDayStore
    self.eventEasterDayBundleStore = EasterDayStore()
    self.eventEasterDayBundleStore:InitPack(eventConfig:Get("easter_egg"))
    self.eventEasterDayBundleStore:SetKey()

    self.eventEasterDayDailyStore = EasterDayDailyStore()
    self.eventEasterDayDailyStore:InitPack(eventConfig:Get("easter_egg"))
    self.eventEasterDayDailyStore:SetKey()

    ---@type SummerDayStore
    self.eventSummerDayBundleStore = SummerDayStore()
    self.eventSummerDayBundleStore:InitPack(eventConfig:Get("summer_day"))
    self.eventSummerDayBundleStore:SetKey()

    self.eventSummerDayDailyStore = SummerDayDailyStore()
    self.eventSummerDayDailyStore:InitPack(eventConfig:Get("summer_day"))
    self.eventSummerDayDailyStore:SetKey()

    ---@type BlossomDayStore
    self.eventBlossomDayBundleStore = BlossomDayStore()
    self.eventBlossomDayBundleStore:InitPack(eventConfig:Get("blossom_day"))
    self.eventBlossomDayBundleStore:SetKey()

    ---@type BlossomDayDailyStore
    self.eventBlossomDayDailyStore = BlossomDayDailyStore()
    self.eventBlossomDayDailyStore:InitPack(eventConfig:Get("blossom_day"))
    self.eventBlossomDayDailyStore:SetKey()

    ---@type QixiFestivalStore
    self.eventQixiFestivalBundleStore = QixiFestivalStore()
    self.eventQixiFestivalBundleStore:InitPack(eventConfig:Get("qixi"))
    self.eventQixiFestivalBundleStore:SetKey()

    ---@type QixiFestivalDailyStore
    self.eventQixiFestivalDailyStore = QixiFestivalDailyStore()
    self.eventQixiFestivalDailyStore:InitPack(eventConfig:Get("qixi"))
    self.eventQixiFestivalDailyStore:SetKey()

    ---@type MayDayStore
    self.eventMayDayBundleStore = MayDayStore()
    self.eventMayDayBundleStore:InitPack(eventConfig:Get("may_day"))
    self.eventMayDayBundleStore:SetKey()
end

--- @param dict Dictionary
function PurchaseConfig:ImportProduct(dict)
    --- @param productConfig ProductConfig
    for _, productConfig in pairs(dict:GetItems()) do
        if self.packBaseConfigDict:IsContainKey(productConfig.productID) then
            XDebug.Error("Content is exist!!! " .. productConfig.productID)
        else
            self.packBaseConfigDict:Add(productConfig.productID, productConfig)
        end
    end
end

function PurchaseConfig:InitPackBase()
    self.packBaseConfigDict = Dictionary()

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.cashShop:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    --for _, purchasePackConfig in pairs(self.hotDeal:GetAllPacks():GetItems()) do
    --    self:ImportProduct(purchasePackConfig.packDict)
    --end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.bundle:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.saleOff:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventArenaPassStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventDailyQuestPassStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventMidAutumnStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventChristmasStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventHalloweenStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventHalloweenDailyStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventBlackFridayCardStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventXmasStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventXmasDailyStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventNewYearStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventNewYearBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventLunarPathStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventLunarExclusiveStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventLunarSpringBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventLunarTigerPathStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventLegacyPathStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventEliteBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventLoveBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventKazetsuBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.lunarSkinBundle:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventNewHeroBundle:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventMergeServerStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventEasterBunnyCardStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventEasterDailyBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventEasterSkinBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.newHeroSkinBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.skinBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventBirthdayBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventBirthdayExclusiveBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventBirthdayPurchaseLevelStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventZodiacBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventHeroReleaseStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.battlePassBundleLevelStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.battlePassBundlePremiumTicketStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.serverWeekBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.serverWeekBundle2Store:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.serverWeekBundle3Store:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.idleEffectBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.randomIdleEffectBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventBlackFridayBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventSkinHotDealBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventSkinChallengeBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventAiryuuBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventTowerOfEitriBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventBossChallengeBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventSeasonalBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventPieceAdventureBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventBlackFridayNewBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventThanksGivingBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventNewYear2023BundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventLunarNewYear2024BundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventMayDayBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventValentine2024BundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventEasterDayBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventSummerDayBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventBlossomDayBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end

    --- @param purchasePackConfig PackOfProducts
    for _, purchasePackConfig in pairs(self.eventQixiFestivalBundleStore:GetAllPacks():GetItems()) do
        self:ImportProduct(purchasePackConfig.packDict)
    end
end

--- @return Dictionary
function PurchaseConfig:GetAllPackBase()
    return self.packBaseConfigDict
end

--- @return ProductConfig
--- @param package string
function PurchaseConfig:GetProductByPackage(package)
    --- @param productConfig ProductConfig
    for _, productConfig in pairs(self:GetAllPackBase():GetItems()) do
        if IS_ANDROID_PLATFORM then
            if package == productConfig.androidPackageName then
                return productConfig
            end
        elseif IS_IOS_PLATFORM then
            if package == productConfig.iosPackageName then
                return productConfig
            end
        elseif package == productConfig.androidPackageName then
            return productConfig
        end
    end
    XDebug.Error("Can't find package: " .. package)
end

--- @return ProductConfig
--- @param key string
function PurchaseConfig:GetPackBase(key)
    local pack = self.packBaseConfigDict:Get(key)
    if pack == nil then
        XDebug.Error(string.format("pack is nil: %s", key))
    end
    return pack
end

--- @return Dictionary
function PurchaseConfig:GetPackBaseDict()
    return self.packBaseConfigDict
end

--- @return ProductConfig
function PurchaseConfig:FindProductConfigFromPackageName(packageName)
    --- @param v ProductConfig
    for _, v in pairs(self.packBaseConfigDict:GetItems()) do
        if v:GetPackageNameByDeviceOs() == packageName then
            return v
        end
    end
    return nil
end

--- @return Dictionary
function PurchaseConfig:GetEventPurchaseConfig()
    local packIdDict = Dictionary()
    local content = CsvReaderUtils.ReadLocalFile(EVENT_PURCHASE_CONFIG_PATH)
    local lines = content:Split('\n')
    for i = 1, #lines do
        local chars = lines[i]:Split(',')
        local name = chars[1]
        if (name ~= nil) then
            packIdDict:Add(name, chars)
        end
        chars[1] = nil

    end
    return packIdDict
end

--- @return CashShop
function PurchaseConfig:GetCashShop()
    return self.cashShop
end

--- @return HotDealStore
function PurchaseConfig:GetHotDeal()
    return self.hotDeal
end

--- @return BundleStore
function PurchaseConfig:GetBundle()
    return self.bundle
end

--- @return SaleOffStore
function PurchaseConfig:GetSaleOff()
    return self.saleOff
end

--- @return EventArenaPassStore
function PurchaseConfig:GetArenaPass()
    return self.eventArenaPassStore
end

--- @return EventDailyQuestPassStore
function PurchaseConfig:GetDailyQuestPass()
    return self.eventDailyQuestPassStore
end

--- @return MidAutumnStore
function PurchaseConfig:GetMidAutumn()
    return self.eventMidAutumnStore
end

--- @return ChristmasStore
function PurchaseConfig:GetChristmas()
    return self.eventChristmasStore
end

--- @return HalloweenStore
function PurchaseConfig:GetHalloween()
    return self.eventHalloweenStore
end

--- @return XmasExclusiveStore
function PurchaseConfig:GetXmasExclusive()
    return self.eventXmasStore
end

--- @return HalloweenStore
function PurchaseConfig:GetHalloweenDaily()
    return self.eventHalloweenDailyStore
end

--- @return XmasDailyStore
function PurchaseConfig:GetXmasDaily()
    return self.eventXmasDailyStore
end

--- @return NewYearBundleStore
function PurchaseConfig:GetNewYearBundle()
    return self.eventNewYearBundleStore
end

--- @return BlackFridayCardStore
function PurchaseConfig:GetBlackFridayCard()
    return self.eventBlackFridayCardStore
end

--- @return BlackFridayGemPackStore
function PurchaseConfig:GetBlackFridayGemPack()
    return self.eventBlackFridayGemPackStore
end

--- @return BlackFridayBundleStore
function PurchaseConfig:GetBlackFridayBundleStore()
    return self.eventBlackFridayBundleStore
end

--- @return NewYearCardStore
function PurchaseConfig:GetNewYearCard()
    return self.eventNewYearStore
end

--- @return LunarExclusiveStore
function PurchaseConfig:GetLunarExclusiveStore()
    return self.eventLunarExclusiveStore
end

--- @return LunarSpringBundleStore
function PurchaseConfig:GetLunarSpringBundleStore()
    return self.eventLunarSpringBundleStore
end

--- @return TigerPathStore
function PurchaseConfig:GetLunarTigerPathStore()
    return self.eventLunarTigerPathStore
end

--- @return LegacyPathStore
function PurchaseConfig:GetLegacyPathStore()
    return self.eventLegacyPathStore
end

--- @return LunarPathStore
function PurchaseConfig:GetLunarPathStore()
    return self.eventLunarPathStore
end

--- @return LunarPathStore
function PurchaseConfig:GetEliteBundleStore()
    return self.eventEliteBundleStore
end

--- @return LunarPathStore
function PurchaseConfig:GetLoveBundleStore()
    return self.eventLoveBundleStore
end

--- @return LunarSkinBundle
function PurchaseConfig:GetLunarSkinBundle()
    return self.lunarSkinBundle
end

--- @return NewHeroBundleStore
function PurchaseConfig:GetNewHeroBundle()
    return self.eventNewHeroBundle
end

--- @return ServerWeekBundleStore
function PurchaseConfig:GetServerWeekBundle()
    return self.serverWeekBundleStore
end

--- @return KazetsuBundleStore
function PurchaseConfig:GetKazetsuBundle()
    return self.eventKazetsuBundleStore
end

--- @return IdleEffectBundleStore
function PurchaseConfig:GetIdleEffectBundle()
    return self.idleEffectBundleStore
end

--- @return IdleEffectBundleStore
function PurchaseConfig:GetRandomIdleEffectBundle()
    return self.randomIdleEffectBundleStore
end

--- @return ServerWeekBundle3Store
function PurchaseConfig:GetServerWeekBundle3()
    return self.serverWeekBundle3Store
end

--- @return ServerWeekBundle2Store
function PurchaseConfig:GetServerWeekBundle2()
    return self.serverWeekBundle2Store
end

--- @return MergeServerStore
function PurchaseConfig:GetMergeServerBundle()
    return self.eventMergeServerStore
end

--- @return EasterBunnyCardStore
function PurchaseConfig:GetEventEasterBunnyCardStore()
    return self.eventEasterBunnyCardStore
end

--- @return EasterDailyBundleStore
function PurchaseConfig:GetEasterDailyBundleStore()
    return self.eventEasterDailyBundleStore
end

--- @return BirthdayBundleStore
function PurchaseConfig:GetBirthdayBundleStore()
    return self.eventBirthdayBundleStore
end

--- @return BirthdayBundleStore
function PurchaseConfig:GetBirthdayExclusiveBundleStore()
    return self.eventBirthdayExclusiveBundleStore
end

--- @return EventBirthdayPurchaseLevelStore
function PurchaseConfig:GetBirthdayPurchaseLevelStore()
    return self.eventBirthdayPurchaseLevelStore
end

--- @return ZodiacBundleStore
function PurchaseConfig:GetZodiacBundleStore()
    return self.eventZodiacBundleStore
end

--- @return EasterSkinBundleStore
function PurchaseConfig:GetEasterLimitedOfferStore()
    return self.eventEasterSkinBundleStore
end

--- @return NewHeroSkinBundleStore
function PurchaseConfig:GetNewHeroSkinBundleStore()
    return self.newHeroSkinBundleStore
end

--- @return NewHeroSkinBundleStore
function PurchaseConfig:GetEventSkinHotDealStore()
    return self.eventSkinHotDealBundleStore
end

--- @return SkinBundleStore
function PurchaseConfig:GetSkinBundleStore()
    return self.skinBundleStore
end

--- @return HeroReleaseStore
function PurchaseConfig:GetHeroReleaseBundleStore()
    return self.eventHeroReleaseStore
end

--- @return SkinChallengeBundleStore
function PurchaseConfig:GetSkinChallengeBundleStore()
    return self.eventSkinChallengeBundleStore
end

--- @return EventAiryuuBundleStore
function PurchaseConfig:GetEventAiryuuBundleStore()
    return self.eventAiryuuBundleStore
end

--- @return EventTowerOfEitriBundleStore
function PurchaseConfig:GetEventTowerOfEitriBundleStore()
    return self.eventTowerOfEitriBundleStore
end

--- @return EventBossChallengeBundleStore
function PurchaseConfig:GetEventBossChallengeBundleStore()
    return self.eventBossChallengeBundleStore
end

--- @return EventSeasonalBundleStore
function PurchaseConfig:GetEventSeasonalBundleStore()
    return self.eventSeasonalBundleStore
end

--- @return EventPieceAdventureBundleStore
function PurchaseConfig:GetEventPieceAdventureBundleStore()
    return self.eventPieceAdventureBundleStore
end

--- @return EventBlackFridayNewBundleStore
function PurchaseConfig:GetEventBlackFridayNewBundleStore()
    return self.eventBlackFridayNewBundleStore
end

--- @return ThanksGivingStore
function PurchaseConfig:GetEventThanksGivingBundleStore()
    return self.eventThanksGivingBundleStore
end

--- @return ThanksGivingDailyStore
function PurchaseConfig:GetThanksGivingDaily()
    return self.eventThanksGivingDailyStore
end

--- @return NewYear2023Store
function PurchaseConfig:GetEventNewYear2023BundleStore()
    return self.eventNewYear2023BundleStore
end

--- @return QixiFestivalStore
function PurchaseConfig:GetEventQixiFestivalBundleStore()
    return self.eventQixiFestivalBundleStore
end

--- @return BlossomDayStore
function PurchaseConfig:GetEventBlossomDayBundleStore()
    return self.eventBlossomDayBundleStore
end

--- @return NewYear2023DailyStore
function PurchaseConfig:GetNewYear2023Daily()
    return self.eventNewYear2023DailyStore
end

--- @return LunarNewYear2024Store
function PurchaseConfig:GetEventLunarNewYear2024BundleStore()
    return self.eventLunarNewYear2024BundleStore
end

--- @return MayDayStore
function PurchaseConfig:GetEventMayDayBundleStore()
    return self.eventMayDayBundleStore
end

--- @return Valentine2024Store
function PurchaseConfig:GetEventValentine2024BundleStore()
    return self.eventValentine2024BundleStore
end

--- @return EasterDayStore
function PurchaseConfig:GetEventEasterDayBundleStore()
    return self.eventEasterDayBundleStore
end

--- @return SummerDayStore
function PurchaseConfig:GetEventSummerDayBundleStore()
    return self.eventSummerDayBundleStore
end

function PurchaseConfig:GetStore(opCode)
    if opCode == OpCode.EVENT_HOT_DEAL_PURCHASE then
        return self:GetHotDeal()
    elseif opCode == OpCode.EVENT_BUNDLE_PURCHASE then
        return self:GetBundle()
    else
        return self:GetCashShop()
    end
end

--- @return PackOfProducts
function PurchaseConfig:GetPack(opCode, dataId)
    local store = self:GetStore(opCode)
    if opCode == OpCode.EVENT_HOT_DEAL_PURCHASE then
        return store:GetPack(dataId)
    elseif opCode == OpCode.EVENT_BUNDLE_PURCHASE then
        return store:GetPack(dataId)
    else
        return store:GetPack(opCode)
    end
end

--- @return PackOfProducts
function PurchaseConfig:GetCurrentPack(opCode)
    if opCode == OpCode.EVENT_HOT_DEAL_PURCHASE then
        return self:GetHotDeal():GetCurrentPack()
    elseif opCode == OpCode.EVENT_BUNDLE_PURCHASE then
        return self:GetBundle():GetCurrentPack()
    else
        return self:GetCashShop():GetPack(opCode)
    end
end

--- @return ProductConfig
function PurchaseConfig:GetProduct(opCode, dataId, productId)
    return self:GetPack(opCode, dataId):GetPackBase(productId)
end

--- @return List
function PurchaseConfig:GetListCampaignStageOpenTrialMonthly()
    if self.listOpenDayTrialMonthly == nil then
        self.listOpenDayTrialMonthly = List()
        local parseCsv = CsvReaderUtils.ReadAndParseLocalFile(CAMPAIGN_STAGE_OPEN_TRIAL_MONTHLY)
        for i = 1, #parseCsv do
            self.listOpenDayTrialMonthly:Add(tonumber(parseCsv[i]['stage']))
        end
    end
    return self.listOpenDayTrialMonthly
end

function PurchaseConfig:GetListFirstTopUpIconReward(indexNumber)
    --print("index number" , indexNumber)
    local iconDataList = List()
    local listRewardRequirePriceConfig = self:GetListFirstTopUpReward(indexNumber)
    if (listRewardRequirePriceConfig ~= nil) then
        for i = 1, listRewardRequirePriceConfig:Count() do
            --- @type RewardInBound
            local resData = listRewardRequirePriceConfig:Get(i)
            iconDataList:Add(resData:GetIconData())
        end
        return iconDataList
    end
end

function PurchaseConfig:InitDictFirstTopUpReward()
    local dicFirstTimeReward = Dictionary()
    local path = FIRST_TIME_REWARD_PATH

    --- @type HeroSummonInBound
    local server = zg.playerData:GetMethod(PlayerDataMethod.SUMMON)
    local firstTopUpDataId = server:GetFirstTopUpDataId()

    if firstTopUpDataId > 0 then
        path = string.format(FIRST_TIME_REWARD_AB_TEST_PATH, firstTopUpDataId)
    end

    local parseCsv = CsvReaderUtils.ReadAndParseLocalFile(path)
    local index
    for i = 1, #parseCsv do
        local tempData = parseCsv[i]
        local itemId = tempData.item_id
        if (itemId ~= nil) then
            index = tonumber(tempData.item_id)
            ---@type RewardRequirePriceConfig
            local rewardRequirePriceConfig = RewardRequirePriceConfig()
            rewardRequirePriceConfig.heroScale = tempData.scale_hero
            local price = tempData.price_require or 0
            price = tonumber(price)
            rewardRequirePriceConfig.priceRequire = price
            rewardRequirePriceConfig.isRequirePrice = price > 0
            rewardRequirePriceConfig.listReward = List()
            dicFirstTimeReward:Add(index, rewardRequirePriceConfig)
        end
        dicFirstTimeReward:Get(index).listReward:Add(RewardInBound.CreateByParams(tempData))
    end
    self.dicFirstTimeReward = dicFirstTimeReward
end

function PurchaseConfig:GetListFirstTopUpReward(indexNumber)
    local _index = tonumber(indexNumber)
    self:InitDictFirstTopUpReward()
    --- @param v RewardRequirePriceConfig
    for _, v in pairs(self.dicFirstTimeReward:GetItems()) do
        v:SetHeroFragmentID()
    end

    if (self.dicFirstTimeReward:IsContainKey(_index)) then
        return self.dicFirstTimeReward:Get(_index).listReward
    else
        return nil
    end
end

function PurchaseConfig:GetListFirstTopUpRewardConfig(indexNumber)
    local _index = tonumber(indexNumber)
    self:InitDictFirstTopUpReward()
    --- @param v RewardRequirePriceConfig
    for _, v in pairs(self.dicFirstTimeReward:GetItems()) do
        v:SetHeroFragmentID()
    end

    if (self.dicFirstTimeReward:IsContainKey(_index)) then
        return self.dicFirstTimeReward:Get(_index)
    else
        return nil
    end
end

--- @return BattlePassBundleLevelStore
function PurchaseConfig:GetBattlePassBundleLevelStore()
    return self.battlePassBundleLevelStore
end

--- @return BattlePassBundlePremiumTicketStore
function PurchaseConfig:GetBattlePassBundlePremiumTicketStore()
    return self.battlePassBundlePremiumTicketStore
end

return PurchaseConfig

