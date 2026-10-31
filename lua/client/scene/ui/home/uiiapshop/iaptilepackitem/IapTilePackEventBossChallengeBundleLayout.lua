require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

local BUY_SUCCESS = 1
local LIMIT_BUY = 0
local BUY_FAIL = 2

--- @class IapTilePackEventBossChallengeBundleLayout : IapTilePackLayout
IapTilePackEventBossChallengeBundleLayout = Class(IapTilePackEventBossChallengeBundleLayout, IapTilePackLayout)

local UNLIMIT_STOCK = -1

--- @param data ProductConfig
function IapTilePackEventBossChallengeBundleLayout:InitData(data)
    --- @type ProductConfig
    self.productConfig = data
    ---@type EventBossChallengeModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BOSS_CHALLENGE)
end

function IapTilePackEventBossChallengeBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "event_boss_challenge", self.packId)
end

function IapTilePackEventBossChallengeBundleLayout:SetPackIcon()
    self:EnablePackIcon(false)
end

function IapTilePackEventBossChallengeBundleLayout:SetTextBuy()
    self.config.textPurchaseLimit.gameObject:SetActive(self.stock > 0)
    self.config.textPurchaseLimit.text = string.format("%s %s",
            UIUtils.SetColorString(UIUtils.red1, LanguageUtils.LocalizeCommon("limited_packs")),
            UIUtils.SetColorString(UIUtils.color6, string.format("%s/%s", self.stock - self.numberOfBought, self.stock)))
    self.item:EnableNotification(self.productConfig.isFree == true and (self.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.stock or self.stock == UNLIMIT_STOCK)
end

function IapTilePackEventBossChallengeBundleLayout:WatchAds()
    VideoRewardedUtils.SetType(1)
    VideoRewardedUtils.SetAction(function()
        self:RequestBuy()
    end)
    IapDataInBound.Validate(function()
        if VideoRewardedUtils.AllowSkipVideo() then
            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "watch_video", 0)
            VideoRewardedUtils.RequestToServer()
        else
            VideoRewardedUtils.OpenRewarded(AdsPlacement.EVENT_BOSS_CHALLENGE_BUNDLE)
        end
    end)
end

function IapTilePackEventBossChallengeBundleLayout:SetTextPrice()
    local dollarPrice = tonumber(self.productConfig.dollarPrice)
    self.priceType = tonumber(self.productConfig.priceType)
    self.numberOfBought = self.eventModel:GetNumberOfBoughtLimitedPack(self.productConfig.id)
    self.numberWatchAds = self.productConfig.numberWatchAds
    self.stock = self.productConfig.stock
    if self.priceType == IapPackPriceType.FREE then
        self.productConfig.isFree = true
        if self.stock > self.numberOfBought and self.numberWatchAds and self.numberOfBought >= self.stock - self.numberWatchAds or self.stock <= self.numberOfBought then
            self.config.buttonAds.gameObject:SetActive(true)
            self.config.textAds.text = LanguageUtils.LocalizeCommon("watch")
        elseif self.stock > self.numberOfBought then
            self.config.textPrice.text = LanguageUtils.LocalizeCommon("free")
        end
    elseif self.priceType == IapPackPriceType.WATCH_ADS then
        self.productConfig.isFree = true
        self.config.buttonAds.gameObject:SetActive(true)
        if self.stock > self.numberOfBought then
            self.config.textAds.text = LanguageUtils.LocalizeCommon("watch")
        end
    elseif self.priceType == IapPackPriceType.GEM then
        self.productConfig.isFree = true
        self.config.iconMoney.gameObject:SetActive(true)
        self.config.iconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.GEM)
        if self.stock > self.numberOfBought then
            self.config.textPrice.text = tostring(dollarPrice)
        end
    else
        self.config.iconMoney.gameObject:SetActive(false)
        self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
    end
end

function IapTilePackEventBossChallengeBundleLayout:OnBuySuccess()
    TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_BOSS_CHALLENGE, self.productConfig.androidPackageName, BUY_SUCCESS)
    self:SetTextBuy()
    self:SetTextPrice()
    if self.buySuccessListener then
        self.buySuccessListener()
    end
end

function IapTilePackEventBossChallengeBundleLayout:OnBuyFail()
    TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_BOSS_CHALLENGE, self.productConfig.androidPackageName, BUY_FAIL)
end

function IapTilePackEventBossChallengeBundleLayout:OnClickBuy()
    if self.numberOfBought < self.stock or self.stock == UNLIMIT_STOCK then
        if self.priceType == IapPackPriceType.WATCH_ADS or
                (self.numberWatchAds and self.priceType == IapPackPriceType.FREE and self.numberOfBought >= self.stock - self.numberWatchAds) then
            self:WatchAds()
        elseif self.priceType == IapPackPriceType.GEM then
            local dollarPrice = tonumber(self.productConfig.dollarPrice)
            local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(
                    RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GEM, dollarPrice))
            if canExchange then
                InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, dollarPrice)
                self:RequestBuy()
            end
        else
            self:RequestBuy()
        end
    else
        TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_BOSS_CHALLENGE, self.productConfig.androidPackageName, LIMIT_BUY)
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end