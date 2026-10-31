require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackZodiacBundleLayout : IapTilePackLayout
IapTilePackZodiacBundleLayout = Class(IapTilePackZodiacBundleLayout, IapTilePackLayout)

--- @param data ZodiacBundleProduct
function IapTilePackZodiacBundleLayout:InitData(data)
    --- @type ZodiacBundleProduct
    self.productConfig = data
    ---@type EventZodiacModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_ZODIAC)
end

function IapTilePackZodiacBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "zodiac_bundle", self.packId)
end

function IapTilePackZodiacBundleLayout:SetPackIcon()
    self:EnablePackIcon(false)
end

function IapTilePackZodiacBundleLayout:OnClickBuy()
    if self:GetNumberOfBought() >= self.productConfig.stock then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    else
        if self.availableAds then
            self:WatchAds()
        elseif self:GetNumberOfBought() < self.productConfig.stock then
            self:RequestBuy()
        end
    end
end

function IapTilePackZodiacBundleLayout:SetTextBuy()
    self.config.textPurchaseLimit.gameObject:SetActive(self.productConfig.stock > 0)
    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self:GetNumberOfBought(), self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self:GetNumberOfBought() > 0))
    self.item:SetActiveColor(self:GetNumberOfBought() < self.productConfig.stock)
end

function IapTilePackZodiacBundleLayout:WatchAds()
    VideoRewardedUtils.SetType(1)
    VideoRewardedUtils.SetAction(function()
        self:RequestBuy()
    end)
    IapDataInBound.Validate(function()
        if VideoRewardedUtils.AllowSkipVideo() then
            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "watch_video", 0)
            VideoRewardedUtils.RequestToServer()
        else
            VideoRewardedUtils.OpenRewarded(AdsPlacement.EVENT_ZODIAC_BUNDLE)
        end
    end)
end

function IapTilePackZodiacBundleLayout:SetTextPrice()
    self:CheckAvailableAds()
    self.config.buttonAds.gameObject:SetActive(self.availableAds)
    if self.availableAds then
        self.config.textAds.text = LanguageUtils.LocalizeCommon("watch")
    end
    if self.productConfig.isFree ~= true then
        self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
    else
        self.config.textPrice.text = LanguageUtils.LocalizeCommon("free")
    end
end

function IapTilePackZodiacBundleLayout:CheckAvailableAds()
    --- @type boolean
    self.availableAds = self.productConfig.numberWatchAds ~= nil and self:GetNumberOfBought() <= self.productConfig.numberWatchAds
end

function IapTilePackZodiacBundleLayout:GetNumberOfBought()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_ZODIAC)
    return self.eventModel:GetLimitedPackStatisticsInBound(self.productConfig.id):GetNumberOfBought()
end

