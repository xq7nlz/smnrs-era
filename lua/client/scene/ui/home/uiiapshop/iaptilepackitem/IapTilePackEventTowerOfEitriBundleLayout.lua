require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

local BUY_SUCCESS = 1
local LIMIT_BUY = 0
local BUY_FAIL = 2

--- @class IapTilePackEventTowerOfEitriBundleLayout : IapTilePackLayout
IapTilePackEventTowerOfEitriBundleLayout = Class(IapTilePackEventTowerOfEitriBundleLayout, IapTilePackLayout)

--- @param data ProductConfig
function IapTilePackEventTowerOfEitriBundleLayout:InitData(data)
    --- @type ProductConfig
    self.productConfig = data
    ---@type EventTowerOfEitriModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_TOWER_OF_EITRI)
end

function IapTilePackEventTowerOfEitriBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "event_tower_of_eitri", self.packId)
end

function IapTilePackEventTowerOfEitriBundleLayout:SetPackIcon()
    self:EnablePackIcon(false)
end

function IapTilePackEventTowerOfEitriBundleLayout:SetTextBuy()
    self.config.textPurchaseLimit.gameObject:SetActive(self.productConfig.stock > 0)
    self.config.textPurchaseLimit.text = string.format("%s %s",
            UIUtils.SetColorString(UIUtils.red1, LanguageUtils.LocalizeCommon("limited_packs")),
            UIUtils.SetColorString(UIUtils.color6, string.format("%s/%s", self.stock - self.numberOfBought, self.stock)))
    self.item:EnableNotification(self.productConfig.isFree == true and (self.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.stock)
end

function IapTilePackEventTowerOfEitriBundleLayout:WatchAds()
    VideoRewardedUtils.SetType(1)
    VideoRewardedUtils.SetAction(function()
        self:RequestBuy()
    end)
    IapDataInBound.Validate(function()
        if VideoRewardedUtils.AllowSkipVideo() then
            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "watch_video", 0)
            VideoRewardedUtils.RequestToServer()
        else
            VideoRewardedUtils.OpenRewarded(AdsPlacement.EVENT_TOWER_OF_EITRI_BUNDLE)
        end
    end)
end

function IapTilePackEventTowerOfEitriBundleLayout:SetTextPrice()
    if self.updateTime then
        self:RemoveUpdateTime()
    end
    local dollarPrice = tonumber(self.productConfig.dollarPrice)
    self.priceType = tonumber(self.productConfig.priceType)
    self.numberOfBought = self.eventModel:GetNumberOfBoughtLimitedPack(self.productConfig.id)
    self.numberWatchAds = self.productConfig.numberWatchAds
    self.stock = self.productConfig.stock
    if self.priceType == IapPackPriceType.FREE then
        self.productConfig.isFree = true
        if self.stock > self.numberOfBought and self.numberWatchAds and self.numberOfBought >= self.stock - self.numberWatchAds then
            self.config.buttonAds.gameObject:SetActive(true)
            self.config.textAds.text = LanguageUtils.LocalizeCommon("watch")
        elseif self.stock > self.numberOfBought then
            self.config.textPrice.text = LanguageUtils.LocalizeCommon("free")
        else
            self:InitUpdateTime(self.priceType)
            self:StartUpdateTime()
        end
    elseif self.priceType == IapPackPriceType.WATCH_ADS then
        self.productConfig.isFree = true
        self.config.buttonAds.gameObject:SetActive(true)
        if self.stock > self.numberOfBought then
            self.config.textAds.text = LanguageUtils.LocalizeCommon("watch")
        else
            self:InitUpdateTime(self.priceType)
            self:StartUpdateTime()
        end
    elseif self.priceType == IapPackPriceType.GEM then
        self.productConfig.isFree = true
        self.config.iconMoney.gameObject:SetActive(true)
        self.config.iconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.GEM)
        if self.stock > self.numberOfBought then
            self.config.textPrice.text = tostring(dollarPrice)
        else
            self:InitUpdateTime(self.priceType)
            self:StartUpdateTime()
        end
    else
        self.config.iconMoney.gameObject:SetActive(false)
        self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
    end
end

function IapTilePackEventTowerOfEitriBundleLayout:OnBuySuccess()
    TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_DRAGON_TOWER, self.productConfig.androidPackageName, BUY_SUCCESS)
    self:SetTextBuy()
    self:SetTextPrice()
    if self.buySuccessListener then
        self.buySuccessListener()
    end
end

function IapTilePackEventTowerOfEitriBundleLayout:OnBuyFail()
    TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_DRAGON_TOWER, self.productConfig.androidPackageName, BUY_FAIL)
end

function IapTilePackEventTowerOfEitriBundleLayout:OnClickBuy()
    if self.numberOfBought < self.stock then
        if self.priceType == IapPackPriceType.WATCH_ADS or
                (self.numberWatchAds and self.priceType == IapPackPriceType.FREE and self.numberOfBought >= self.stock - self.numberWatchAds) then
            self:WatchAds()
        elseif self.priceType == IapPackPriceType.GEM then
            local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(
                    RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GEM, IapPackPriceType.GEM))
            if canExchange then
                InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, IapPackPriceType.GEM)
                self:RequestBuy()
            end
        else
            self:RequestBuy()
        end
    else
        TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_DRAGON_TOWER, self.productConfig.androidPackageName, LIMIT_BUY)
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

---@param priceType IapPackPriceType
function IapTilePackEventTowerOfEitriBundleLayout:InitUpdateTime(priceType)
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
        elseif priceType == IapPackPriceType.FREE or priceType == IapPackPriceType.GEM then
            self.config.textPrice.text = string.format("%s",
                    UIUtils.SetColorString(UIUtils.green_light, TimeUtils.SecondsToClock(self.timeRefresh)))
        end
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
        end
    end
end

function IapTilePackEventTowerOfEitriBundleLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function IapTilePackEventTowerOfEitriBundleLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

function IapTilePackEventTowerOfEitriBundleLayout:RemoveUpdateTime()
    if self.updateTime then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end
