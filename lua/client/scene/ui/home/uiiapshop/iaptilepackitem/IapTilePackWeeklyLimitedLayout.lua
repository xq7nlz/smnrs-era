--- @class
---IapTilePackWeeklyLimitedLayout : IapTilePackLayout
IapTilePackWeeklyLimitedLayout = Class(IapTilePackWeeklyLimitedLayout, IapTilePackLayout)

--- @param iapTilePackItem IapTilePackItem
--- @param opCode OpCode
function IapTilePackWeeklyLimitedLayout:Ctor(iapTilePackItem, packViewType, opCode)
    IapTilePackLayout.Ctor(self,iapTilePackItem, packViewType, opCode)
end

--- @param data LimitedProduct
function IapTilePackWeeklyLimitedLayout:InitData(data)
    --- @type LimitedProduct
    self.productConfig = data
end

function IapTilePackWeeklyLimitedLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "daily_limited", self.packId)
end

function IapTilePackWeeklyLimitedLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLimitedPack, self.packId)
    self.config.packIcon:SetNativeSize()
end


function IapTilePackWeeklyLimitedLayout:SetReward()
    self:GetEventExtraReward()
    IapTilePackLayout.SetReward(self)
end

function IapTilePackWeeklyLimitedLayout:GetEventExtraReward()
    local eventBirthdayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
    if eventBirthdayModel and eventBirthdayModel:IsOpening() then
        if self.productConfig.eventExtraRewardList:Count() == 0 and self.productConfig.isFree == false then
            self.productConfig.enableVipPointTag = true

            local dataId = eventBirthdayModel.timeData.dataId
            local bundleId = string.sub(self.productConfig.androidPackageName, string.len(self.productConfig.androidPackageName)  - 25,string.len(self.productConfig.androidPackageName))
            --- @type EventBirthdayConfig
            local eventBirthdayConfig = ResourceMgr.GetEventConfig():GetData(EventTimeType.EVENT_BIRTHDAY, dataId)
            self.productConfig.eventExtraRewardList:Add(eventBirthdayConfig:GetWeeklyBundleBonusReward(dataId, bundleId))
        end
    else
        self.productConfig.eventExtraRewardList:Clear()
        self.productConfig.enableVipPointTag = false
    end
end

function IapTilePackWeeklyLimitedLayout:OnClickBuy()
    if self.availableAds then
        self:WatchAds()
    elseif self:GetNumberOfBought() < self.productConfig.stock then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

function IapTilePackWeeklyLimitedLayout:SetTextBuy()
    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self:GetNumberOfBought(), self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self:GetNumberOfBought() > 0))
    self.item:SetActiveColor(self:GetNumberOfBought() < self.productConfig.stock)
end

function IapTilePackWeeklyLimitedLayout:WatchAds()
    VideoRewardedUtils.SetType(1)
    VideoRewardedUtils.SetAction(function()
        self:RequestBuy()
    end)
    IapDataInBound.Validate(function()
        if VideoRewardedUtils.AllowSkipVideo() then
            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "watch_video", 0)
            VideoRewardedUtils.RequestToServer()
        else
            VideoRewardedUtils.OpenRewarded(AdsPlacement.SHOP_WEEKLY_BUNDLE)
        end
    end)
end

function IapTilePackWeeklyLimitedLayout:SetTextPrice()
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

function IapTilePackWeeklyLimitedLayout:GetNumberOfBought()
    return zg.playerData:GetIAP():GetLimitedPackStatisticsInBound(self.productConfig.id):GetNumberOfBought()
end

function IapTilePackWeeklyLimitedLayout:CheckAvailableAds()
    --- @type boolean
    self.availableAds = self.productConfig.numberWatchAds ~= nil and self:GetNumberOfBought() >= 1 and self:GetNumberOfBought() < self.productConfig.numberWatchAds + 1
end