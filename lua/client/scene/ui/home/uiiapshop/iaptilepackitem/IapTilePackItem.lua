require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackLayout"

--- @class IapTilePackItem : IconView
IapTilePackItem = Class(IapTilePackItem, IconView)

function IapTilePackItem:Ctor()
    --- @type IapTilePackItemConfig
    self.config = nil
    --- @type UIResItemRawPack
    self.rewardItem = nil
    --- @type UIResItemRawPack
    self.rewardVip = nil
    --- @type OpCode
    self.opCode = OpCode.PURCHASE_RAW_PACK
    --- @type number
    self.packId = nil
    --- @type number
    self.packKey = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type IapTilePackLayout
    self.layout = nil
    IconView.Ctor(self)
end

function IapTilePackItem:SetPrefabName()
    self.prefabName = 'iap_tile_pack_item'
    self.uiPoolType = UIPoolType.IapTilePackItem
end

--- @param transform UnityEngine_Transform
function IapTilePackItem:SetConfig(transform)
    self.config = UIBaseConfig(transform)

    self:InitButtonListener()
end

function IapTilePackItem:InitLocalization()
    if self.config.textInstantReward ~= nil then
        self.config.textInstantReward.text = LanguageUtils.LocalizeCommon("instant_reward")
    end
end

--- @param packViewType PackViewType
function IapTilePackItem:SetViewIconData(packViewType, data, listener)
    self:GetLayout(packViewType)
    self.layout:SetData(data, listener)
end

--- @param packData RawProduct
function IapTilePackItem:SetIconData(packData)
    self.iconData = packData
    self:SetPackKey()

    self.config.textBuyValue.text = LanguageUtils.LocalizeCommon("buy")

    self.config.iconGemSet.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconRawPack, self.packId)
    self.config.iconGemSet:SetNativeSize()
    if self.config.textPackage ~= nil then
        self.config.textPackage.text = LanguageUtils.LocalizeCommon(string.format("raw_pack_%d", self.packId))
    end
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(ClientConfigUtils.GetPurchaseKey(self.opCode, self.packId))

    self:SetRewardList()
end

function IapTilePackItem:SetPackKey()
    self.packId = self.iconData.id
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.opCode, self.packId)
end

function IapTilePackItem:SetRewardList()
    if self.iconData.rewardList:Count() == 2 then
        assert(self.rewardItem == nil)
        --- @type RewardInBound
        local rewardInBound = self.iconData.rewardList:Get(1)
        local content = ClientMathUtils.ConvertingCalculation(rewardInBound.number)
        --- @type UIResItemRawPack
        self.rewardItem = SmartPoolUtils.CreateResItemRawPack(rewardInBound.id, content, self.config.rewardAnchor)

        local vipReward = self.iconData.rewardList:Get(2)
        self.rewardVip = SmartPoolUtils.CreateResItemRawPack(MoneyType.VIP_POINT, vipReward.number, self.config.resVipAnchor)

        self:UpdateViewBonus()
    else
        XDebug.Error("multi rewards didn't support. Update code now. Use ItemTableView, reference PopupRewardView")
    end
end

function IapTilePackItem:UpdateViewBonus()
    if self.iconData.bonusReward and self.iconData:HasBought() == false then
        self.config.iconFirstPurchase:SetActive(true)
        self.config.textBonus.text = string.format("+%d", ClientMathUtils.ConvertingCalculation(self.iconData.bonusReward.number))
    else
        self.config.iconFirstPurchase:SetActive(false)
    end
end

function IapTilePackItem:InitButtonListener()
    self.config.button.onClick:RemoveAllListeners()
    self.config.button.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if self.layout ~= nil then
            self.layout:OnClickBuy()
        end
    end)
end

--- @param packViewType PackViewType
function IapTilePackItem:GetLayout(packViewType)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(packViewType)
    if self.layout == nil then
        if packViewType == PackViewType.EVENT_BUNDLE then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackEventBundleLayout"
            self.layout = IapTilePackEventBundleLayout(self, packViewType, OpCode.EVENT_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.DAILY_LIMITED_PACK then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"
            self.layout = IapTilePackDailyLimitedLayout(self, packViewType, OpCode.PURCHASE_LIMITED_PACK)
        elseif packViewType == PackViewType.DAILY_LIMITED_HALLOWEEN_PACK then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackHalloweenLayout"
            self.layout = IapTilePackHalloweenLayout(self, packViewType, OpCode.EVENT_HALLOWEEN_DAILY_PURCHASE)
        elseif packViewType == PackViewType.DAILY_LIMITED_XMAS_PACK then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackXmasLayout"
            self.layout = IapTilePackXmasLayout(self, packViewType, OpCode.EVENT_CHRISTMAS_DAILY_PURCHASE)
        elseif packViewType == PackViewType.EVENT_NEW_YEAR_BUNDLE then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackNewYearLayout"
            self.layout = IapTilePackNewYearLayout(self, packViewType, OpCode.EVENT_NEW_YEAR_DAILY_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.DAILY_LIMITED_BIRTHDAY then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyBirthdayLayout"
            self.layout = IapTilePackDailyBirthdayLayout(self, packViewType, OpCode.EVENT_BIRTHDAY_EXCLUSIVE_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.WEEKLY_LIMITED_PACK then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackWeeklyLimitedLayout"
            self.layout = IapTilePackWeeklyLimitedLayout(self, packViewType, OpCode.PURCHASE_LIMITED_PACK)
        elseif packViewType == PackViewType.MONTHLY_LIMITED_PACK then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"
            self.layout = IapTilePackDailyLimitedLayout(self, packViewType, OpCode.PURCHASE_LIMITED_PACK)
        elseif packViewType == PackViewType.RAW_PACK then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTileRawPackLayout"
            self.layout = IapTileRawPackLayout(self, packViewType, OpCode.PURCHASE_RAW_PACK)
        elseif packViewType == PackViewType.ELITE_BUNDLE then
            require "lua.client.scene.ui.home.uiEventLunarNewYear.eventLayout.eliteBundle.IapTilePackEliteBundleLayout"
            self.layout = IapTilePackEliteBundleLayout(self, packViewType, OpCode.EVENT_LUNAR_NEW_YEAR_ELITE_STORE_PURCHASE)
        elseif packViewType == PackViewType.VALENTINE_BUNDLE then
            require "lua.client.scene.ui.home.uiEventValentine.eventLayout.bundle.IapTilePackValentineBundleLayout"
            self.layout = IapTilePackValentineBundleLayout(self, packViewType, OpCode.EVENT_VALENTINE_LOVE_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.KAZETSU_BUNDLE then
            require "lua.client.scene.ui.home.uiEventKazetsu.eventLayout.bundle.IapTilePackKazetsuBundleLayout"
            self.layout = IapTilePackKazetsuBundleLayout(self, packViewType, OpCode.EVENT_KAZETSU_LIMITED_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.NEW_HERO_BUNDLE then
            require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.bundle.IapTilePackNewHeroBundleLayout"
            self.layout = IapTilePackNewHeroBundleLayout(self, packViewType, OpCode.EVENT_NEW_HERO_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.DAILY_LIMITED_EASTER_PACK then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyEasterLayout"
            self.layout = IapTilePackDailyEasterLayout(self, packViewType, OpCode.EVENT_EASTER_DAILY_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.WELCOME_BACK_BUNDLE then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackWelcomeBackLayout"
            self.layout = IapTilePackWelcomeBackLayout(self, packViewType, OpCode.COMEBACK_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.EVENT_SKIN_BUNDLE_1
                or packViewType == PackViewType.EVENT_SKIN_BUNDLE_2 then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackSkinBundleLayout"
            self.layout = IapTilePackSkinBundleLayout(self, packViewType)
        elseif packViewType == PackViewType.HERO_RELEASE_BUNDLE then
            require "lua.client.scene.ui.home.uiEventHeroRelease.uiEventHeroReleaseLayout.bundle.IapTilePackHeroReleaseBundleLayout"
            self.layout = IapTilePackHeroReleaseBundleLayout(self, packViewType, OpCode.EVENT_HERO_RELEASE_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.EASTER_BUNDLE then
            require "lua.client.scene.ui.home.uiEventEasterEgg.UIEventEasterEggLayout.Bundle.IapTilePackEasterBundleLayout"
            self.layout = IapTilePackEasterBundleLayout(self, packViewType, OpCode.EVENT_EASTER_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.BIRTHDAY_BUNDLE then
            require "lua.client.scene.ui.home.uiEventBirthday.layout.bundle.IapTilePackBirthdayBundleLayout"
            self.layout = IapTilePackBirthdayBundleLayout(self, packViewType, OpCode.EVENT_BIRTHDAY_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.ZODIAC_BUNDLE then
            require "lua.client.scene.ui.home.uiEventZodiac.layout.bundle.IapTilePackZodiacBundleLayout"
            self.layout = IapTilePackZodiacBundleLayout(self, packViewType, OpCode.EVENT_ZODIAC_BUNDLE_PURCHASE_HANDLER)
        elseif packViewType == PackViewType.BLACK_FRIDAY_BUNDLE then
            require "lua.client.scene.ui.home.uiEventBlackFriday.uiEventBlackFridayLayout.Bundle.IapTileBlackFridayBundleLayout"
            self.layout = IapTileBlackFridayBundleLayout(self, packViewType, OpCode.EVENT_BLACK_FRIDAY_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.SKIN_CHALLENGE_BUNDLE then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackSkinChallengeBundleLayout"
            self.layout = IapTilePackSkinChallengeBundleLayout(self, packViewType, OpCode.EVENT_SKIN_CHALLENGE_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.EVENT_AIRYUU_BUNDLE then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackEventAiryuuBundleLayout"
            self.layout = IapTilePackEventAiryuuBundleLayout(self, packViewType, OpCode.EVENT_HERO_AIRYUU_BUNDLE)
        elseif packViewType == PackViewType.EVENT_TOWER_OF_EITRI_BUNDLE then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackEventTowerOfEitriBundleLayout"
            self.layout = IapTilePackEventTowerOfEitriBundleLayout(self, packViewType, OpCode.EVENT_DRAGON_TOWER_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.EVENT_SEASONAL_BUNDLE then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackEventSeasonalBundleLayout"
            self.layout = IapTilePackEventSeasonalBundleLayout(self, packViewType, OpCode.EVENT_SEASONAL_BUNDLE)
        elseif packViewType == PackViewType.EVENT_MID_AUTUMN_BUNDLE then
            require "lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.festivalMarket.IapTilePackMidAutumnBundleLayout"
            self.layout = IapTilePackMidAutumnBundleLayout(self, packViewType, OpCode.EVENT_MID_AUTUMN_PURCHASE)
        elseif packViewType == PackViewType.EVENT_HALLOWEEN_BUNDLE then
            require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventShop.IapTilePackHalloweenBundleLayout"
            self.layout = IapTilePackHalloweenBundleLayout(self, packViewType, OpCode.EVENT_HALLOWEEN_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.EVENT_BOSS_CHALLENGE_BUNDLE then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackEventBossChallengeBundleLayout"
            self.layout = IapTilePackEventBossChallengeBundleLayout(self, packViewType, OpCode.EVENT_BOSS_CHALLENGE_PURCHASE)
        elseif packViewType == PackViewType.EVENT_PIECE_ADVENTURE_BUNDLE then
            require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackEventPieceAdventureBundleLayout"
            self.layout = IapTilePackEventPieceAdventureBundleLayout(self, packViewType, OpCode.EVENT_PIECE_ADVENTURE_PURCHASE)
        elseif packViewType == PackViewType.EVENT_THANKS_GIVING_BUNDLE then
            require "lua.client.scene.ui.home.uiEventThankGiving.EventLayout.EventShop.IapTilePackThanksGivingBundleLayout"
            self.layout = IapTilePackThanksGivingBundleLayout(self, packViewType, OpCode.EVENT_THANKS_GIVING_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.EVENT_CHRISTMAS_BUNDLE then
            require "lua.client.scene.ui.home.uiEventChristmas.eventLayout.market.IapTilePackChristmasBundleLayout"
            self.layout = IapTilePackChristmasBundleLayout(self, packViewType, OpCode.EVENT_CHRISTMAS_PURCHASE)
        elseif packViewType == PackViewType.EVENT_NEW_YEAR_2023_BUNDLE then
            require "lua.client.scene.ui.home.uiEventNewYear2023.EventLayout.shop.IapTilePackNewYear2023BundleLayout"
            self.layout = IapTilePackNewYear2023BundleLayout(self, packViewType, OpCode.EVENT_NEW_YEAR_2023_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.EVENT_LUNAR_NEW_YEAR_2024_BUNDLE then
            require "lua.client.scene.ui.home.uiEventLunarNewYear2024.EventLayout.shop.IapTilePackLunarNewYear2024BundleLayout"
            self.layout = IapTilePackLunarNewYear2024BundleLayout(self, packViewType, OpCode.EVENT_LUNAR_NEW_YEAR_2024_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.EVENT_VALENTINE_2024_BUNDLE then
            require "lua.client.scene.ui.home.uiEventValentine2024.EventLayout.shop.IapTilePackValentine2024BundleLayout"
            self.layout = IapTilePackValentine2024BundleLayout(self, packViewType, OpCode.EVENT_VALENTINE_2024_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.EVENT_EASTER_DAY_BUNDLE then
            require "lua.client.scene.ui.home.uiEventEasterDay.EventLayout.EventShop.IapTilePackEasterDayBundleLayout"
            self.layout = IapTilePackEasterDayBundleLayout(self, packViewType, OpCode.EVENT_EASTERS_EGG_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.EVENT_SUMMER_DAY_BUNDLE then
            require "lua.client.scene.ui.home.uiEventSummerDay.EventLayout.EventShop.IapTilePackSummerDayBundleLayout"
            self.layout = IapTilePackSummerDayBundleLayout(self, packViewType, OpCode.EVENT_SUMMER_DAY_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.EVENT_BLOSSOM_DAY_BUNDLE then
            require "lua.client.scene.ui.home.uiEventBlossomDay.EventLayout.shop.IapTilePackBlossomDayBundleLayout"
            self.layout = IapTilePackBlossomDayBundleLayout(self, packViewType, OpCode.EVENT_BLOSSOM_DAY_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.EVENT_QIXI_FESTIVAL_BUNDLE then
            require "lua.client.scene.ui.home.uiEventQixiFestival.EventLayout.shop.IapTilePackQixiFestivalBundleLayout"
            self.layout = IapTilePackQixiFestivalBundleLayout(self, packViewType, OpCode.EVENT_QIXI_BUNDLE_PURCHASE)
        elseif packViewType == PackViewType.EVENT_MAY_DAY_BUNDLE then
            require "lua.client.scene.ui.home.uiEventMayDay.EventLayout.shop.IapTilePackMayDayBundleLayout"
            self.layout = IapTilePackMayDayBundleLayout(self, packViewType, OpCode.EVENT_MAY_DAY_BUNDLE_PURCHASE)
        end
        self.layoutDict:Add(packViewType, self.layout)
    end
end

function IapTilePackItem:DisableCommon()
    self:EnableNotification(false)
    self.config.bonus1stPurchase:SetActive(false)
    if self.config.hotProfit then
        self.config.hotProfit.gameObject:SetActive(false)
    end
end

function IapTilePackItem:ReturnPool()
    self:HideLayout()
    IconView.ReturnPool(self)
end

function IapTilePackItem:HideLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end

function IapTilePackItem:EnableNotification(isEnable)
    self.config.notification:SetActive(isEnable)
end

--- @return void
function IapTilePackItem:SetActiveColorObject(gameObject, isActive)
    UIUtils.SetActiveColor(gameObject, isActive)
end

return IapTilePackItem