--- @class IapTilePackDailyLimitedLayout : IapTilePackLayout
IapTilePackDailyLimitedLayout = Class(IapTilePackDailyLimitedLayout, IapTilePackLayout)

--- @param data LimitedProduct
function IapTilePackDailyLimitedLayout:InitData(data)
    --- @type LimitedProduct
    self.productConfig = data
end

function IapTilePackDailyLimitedLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "daily_limited", self.packId)
end

function IapTilePackDailyLimitedLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLimitedPack, self.packId)
    self.config.packIcon:SetNativeSize()
end

function IapTilePackDailyLimitedLayout:OnClickBuy()
    if self.availableAds then
        self:WatchAds()
    elseif self:GetNumberOfBought() < self.productConfig.stock then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

function IapTilePackDailyLimitedLayout:WatchAds()
    VideoRewardedUtils.SetType(1)
    VideoRewardedUtils.SetAction(function()
        self:RequestBuy()
    end)
    IapDataInBound.Validate(function()
        if VideoRewardedUtils.AllowSkipVideo() then
            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "watch_video", 0)
            VideoRewardedUtils.RequestToServer()
        else
            VideoRewardedUtils.OpenRewarded(AdsPlacement.SHOP_DAILY_BUNDLE)
        end
    end)
end

function IapTilePackDailyLimitedLayout:SetTextBuy()
    local numberOfBought = self:GetNumberOfBought()
    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - numberOfBought > 0))
    self.item:SetActiveColor(numberOfBought < self.productConfig.stock)
end

function IapTilePackDailyLimitedLayout:SetTextPrice()
    self:CheckAvailableAds()
    self.config.buttonAds.gameObject:SetActive(self.availableAds)
    if self.productConfig.isFree ~= true then
        self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
    else
        if self.availableAds then
            self.config.textAds.text = LanguageUtils.LocalizeCommon("watch")
        else
            self.config.textPrice.text = LanguageUtils.LocalizeCommon("free")
        end
    end
end

function IapTilePackDailyLimitedLayout:GetNumberOfBought()
    return zg.playerData:GetIAP():GetLimitedPackStatisticsInBound(self.productConfig.id):GetNumberOfBought()
end


function IapTilePackDailyLimitedLayout:CheckAvailableAds()
    local numberOfBought = self:GetNumberOfBought()
    --- @type boolean
    self.availableAds = self.productConfig.numberWatchAds ~= nil and numberOfBought >= 1 and numberOfBought < self.productConfig.numberWatchAds + 1
end