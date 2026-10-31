require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackEventAiryuuBundleLayout : IapTilePackLayout
IapTilePackEventAiryuuBundleLayout = Class(IapTilePackEventAiryuuBundleLayout, IapTilePackLayout)

--- @param data EventBackFridayBundleProduct
function IapTilePackEventAiryuuBundleLayout:InitData(data)
    --- @type EventBackFridayBundleProduct
    self.productConfig = data
    ---@type EventAiryuuModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_AIRYUU)
end

function IapTilePackEventAiryuuBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "event_airyuu", self.packId)
end

function IapTilePackEventAiryuuBundleLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLimitedPackEventAiryuuBundle, self.packId)
    self.config.packIcon:SetNativeSize()
end

function IapTilePackEventAiryuuBundleLayout:SetTextBuy()
    self.numberOfBought = self.eventModel:GetNumberBuy(self.productConfig.id)
    self.config.textPurchaseLimit.text = string.format("%s %s",
            UIUtils.SetColorString(UIUtils.green_light, LanguageUtils.LocalizeCommon("limited_packs")),
            UIUtils.SetColorString(UIUtils.color6, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))
    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock)
end

function IapTilePackEventAiryuuBundleLayout:WatchAds()
    VideoRewardedUtils.SetType(1)
    VideoRewardedUtils.SetAction(function()
        self:RequestBuy()
    end)
    IapDataInBound.Validate(function()
        if VideoRewardedUtils.AllowSkipVideo() then
            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "watch_video", 0)
            VideoRewardedUtils.RequestToServer()
        else
            VideoRewardedUtils.OpenRewarded(AdsPlacement.EVENT_AIRYUU_BUNDLE)
        end
    end)
end

function IapTilePackEventAiryuuBundleLayout:SetTextPrice()
    if self.updateTime then
        self:RemoveUpdateTime()
    end
    local dollarPrice = tonumber(self.productConfig.dollarPrice)
    local priceType = tonumber(self.productConfig.priceType)
    if priceType == IapPackPriceType.FREE then
        self.productConfig.isFree = true
        if self.productConfig.stock > self.eventModel:GetNumberOfBoughtLimitedPack(self.productConfig.id) then
            self.config.textPrice.text = LanguageUtils.LocalizeCommon("free")
        else
            self:InitUpdateTime(priceType)
            self:StartUpdateTime()
        end
    elseif priceType == IapPackPriceType.WATCH_ADS then
        self.productConfig.isFree = true
        self.config.buttonAds.gameObject:SetActive(true)
        if self.productConfig.stock > self.eventModel:GetNumberBuy(self.productConfig.id) then
            self.config.textAds.text = LanguageUtils.LocalizeCommon("watch")
        else
            self:InitUpdateTime(priceType)
            self:StartUpdateTime()
        end
    elseif priceType == IapPackPriceType.GEM then
        self.productConfig.isFree = true
        self.config.iconMoneyType.gameObject:SetActive(true)
        self.config.iconMoneyType.sprite = ResourceLoadUtils.LoadMoneyIcon(MoneyType.GEM)
        if self.productConfig.stock > self.eventModel:GetNumberBuy(self.productConfig.id) then
            self.config.textPrice.text = tostring(dollarPrice)
        else
            self:InitUpdateTime(priceType)
            self:StartUpdateTime()
        end
    else
        self.config.iconMoneyType.gameObject:SetActive(false)
        if self.productConfig.id == 3 or self.productConfig.id == 4 then
            if self.productConfig.stock <= self.eventModel:GetNumberBuy(self.productConfig.id) then
                self:InitUpdateTime(priceType)
                self:StartUpdateTime()
            else
                self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
            end
        else
            self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
        end
    end
end

function IapTilePackEventAiryuuBundleLayout:CheckAvailableAds()
    --- @type boolean
    self.availableAds = self.eventModel:HasAdsBundleLeft()
end

function IapTilePackEventAiryuuBundleLayout:OnClickBuy()
    if self.eventModel:GetNumberBuy(self.productConfig.id) < self.productConfig.stock then
        local priceType = tonumber(self.productConfig.priceType)
        if priceType == IapPackPriceType.WATCH_ADS then
            self:WatchAds()
        elseif priceType == IapPackPriceType.GEM then
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
function IapTilePackEventAiryuuBundleLayout:InitUpdateTime(priceType)
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
        elseif priceType == IapPackPriceType.FREE or priceType == IapPackPriceType.GEM or priceType == IapPackPriceType.DOLLAR then
            self.config.textPrice.text = string.format("%s",
                    UIUtils.SetColorString(UIUtils.green_light, TimeUtils.SecondsToClock(self.timeRefresh)))
        end
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
        end
    end
end

function IapTilePackEventAiryuuBundleLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function IapTilePackEventAiryuuBundleLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

function IapTilePackEventAiryuuBundleLayout:RemoveUpdateTime()
    if self.updateTime then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end
