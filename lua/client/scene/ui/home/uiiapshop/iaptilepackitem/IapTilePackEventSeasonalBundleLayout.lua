require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackEventSeasonalBundleLayout : IapTilePackLayout
IapTilePackEventSeasonalBundleLayout = Class(IapTilePackEventSeasonalBundleLayout, IapTilePackLayout)

--- @param data ProductConfig
function IapTilePackEventSeasonalBundleLayout:InitData(data)
    --- @type ProductConfig
    self.productConfig = data
    ---@type EventSeasonalModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SEASONAL)
end

function IapTilePackEventSeasonalBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "event_seasonal", self.packId)
end

function IapTilePackEventSeasonalBundleLayout:SetPackIcon()
    self:EnablePackIcon(false)
end

function IapTilePackEventSeasonalBundleLayout:SetTextBuy()
    self.config.textPurchaseLimit.text = string.format("%s %s",
            UIUtils.SetColorString(UIUtils.red1, LanguageUtils.LocalizeCommon("limited_packs")),
            UIUtils.SetColorString(UIUtils.color6, string.format("%s/%s", self.stock - self.numberOfBought, self.stock)))
    self.item:EnableNotification(self.productConfig.isFree == true and (self.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.stock)
end

function IapTilePackEventSeasonalBundleLayout:WatchAds()
    VideoRewardedUtils.SetType(1)
    VideoRewardedUtils.SetAction(function()
        self:RequestBuy()
    end)
    IapDataInBound.Validate(function()
        if VideoRewardedUtils.AllowSkipVideo() then
            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "watch_video", 0)
            VideoRewardedUtils.RequestToServer()
        else
            VideoRewardedUtils.OpenRewarded(AdsPlacement.EVENT_SEASONAL_BUNDLE)
        end
    end)
end

function IapTilePackEventSeasonalBundleLayout:SetTextPrice()
    if self.updateTime then
        self:RemoveUpdateTime()
    end
    local dollarPrice = tonumber(self.productConfig.dollarPrice)
    self.priceType = tonumber(self.productConfig.priceType)
    self.numberOfBought = self.eventModel:GetNumberOfBoughtLimitedPack(self.productConfig.id)
    self.numberWatchAds = self.productConfig.numberWatchAds
    self.stock = self.productConfig.stock
    self.resetType = tonumber(self.productConfig.resetType)
    if self.priceType == IapPackPriceType.FREE then
        self.productConfig.isFree = true
        if self.stock > self.numberOfBought and self.numberWatchAds and self.numberOfBought >= self.stock - self.numberWatchAds then
            self.config.buttonAds.gameObject:SetActive(true)
            self.config.textAds.text = LanguageUtils.LocalizeCommon("watch")
        elseif self.stock > self.numberOfBought then
            self.config.textPrice.text = LanguageUtils.LocalizeCommon("free")
        else
            self:InitUpdateTime(self.resetType, self.priceType)
            self:StartUpdateTime()
        end
    elseif self.priceType == IapPackPriceType.WATCH_ADS then
        self.productConfig.isFree = true
        self.config.buttonAds.gameObject:SetActive(true)
        if self.stock > self.numberOfBought then
            self.config.textAds.text = LanguageUtils.LocalizeCommon("watch")
        else
            self:InitUpdateTime(self.resetType, self.priceType)
            self:StartUpdateTime()
        end
    elseif self.priceType == IapPackPriceType.GEM then
        self.productConfig.isFree = true
        self.config.iconMoney.gameObject:SetActive(true)
        self.config.iconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.GEM)
        if self.stock > self.numberOfBought then
            self.config.textPrice.text = tostring(dollarPrice)
        else
            self:InitUpdateTime(self.resetType, self.priceType)
            self:StartUpdateTime()
        end
    else
        self.config.iconMoney.gameObject:SetActive(false)
        if self.stock <= self.numberOfBought and  self.resetType == LimitedPackResetType.RESET_BY_DAY then
            self:InitUpdateTime(self.resetType)
            self:StartUpdateTime()
        else
            self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
        end
    end
end

function IapTilePackEventSeasonalBundleLayout:OnClickBuy()
    if self.numberOfBought < self.stock then
        if self.priceType == IapPackPriceType.WATCH_ADS or
                (self.numberWatchAds and self.priceType == IapPackPriceType.FREE and self.numberOfBought >= self.stock - self.numberWatchAds) then
            self:WatchAds()
        elseif self.priceType == IapPackPriceType.GEM then
            local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GEM, IapPackPriceType.GEM))
            if canExchange then
                InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, IapPackPriceType.GEM)
                self:RequestBuy()
            end
        else
            self:RequestBuy()
        end
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

---@param priceType IapPackPriceType
---@param resetType LimitedPackResetType
function IapTilePackEventSeasonalBundleLayout:InitUpdateTime(resetType, priceType)
    if resetType ~= LimitedPackResetType.RESET_BY_DAY then
        return
    end
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        if priceType == IapPackPriceType.WATCH_ADS then
            self.config.textAds.text = string.format("%s",
                    UIUtils.SetColorString(UIUtils.green_light, TimeUtils.SecondsToClock(self.timeRefresh)))
        else
            self.config.textPrice.text = string.format("%s",
                    UIUtils.SetColorString(UIUtils.green_light, TimeUtils.SecondsToClock(self.timeRefresh)))
        end
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
        end
    end
end

function IapTilePackEventSeasonalBundleLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function IapTilePackEventSeasonalBundleLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

function IapTilePackEventSeasonalBundleLayout:RemoveUpdateTime()
    if self.updateTime then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end
