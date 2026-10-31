--- @class IapTilePackEventBundleLayout : IapTilePackLayout
IapTilePackEventBundleLayout = Class(IapTilePackEventBundleLayout, IapTilePackLayout)

--- @param iapTilePackItem IapTilePackItem
--- @param opCode OpCode
function IapTilePackEventBundleLayout:Ctor(iapTilePackItem, packViewType, opCode)
    IapTilePackLayout.Ctor(self, iapTilePackItem, packViewType, opCode)
end

--- @param data PurchasedPackInBound
function IapTilePackEventBundleLayout:InitData(data)
    --- @type PurchasedPackInBound
    self.iconData = data
    --- @type ProductConfig
    self.productConfig = data.config
end

function IapTilePackEventBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "event_bundle", self.packId)
end

function IapTilePackEventBundleLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconEventBundlePack, self.packId)
    self.config.packIcon:SetNativeSize()
end

function IapTilePackEventBundleLayout:OnClickBuy()
    if self.availableAds then
        self:WatchAds()
    elseif self:GetNumberOfBought() < self.productConfig.stock then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

function IapTilePackEventBundleLayout:SetReward()
    self:GetEventExtraReward()
    IapTilePackLayout.SetReward(self)
end

function IapTilePackEventBundleLayout:SetTextPrice()
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

function IapTilePackEventBundleLayout:SetTextBuy()
    --local color = UIUtils.green_dark
    --if self.productConfig.stock - self.iconData.numberOfBought == 0 then
    --    color = UIUtils.white
    --end
    local numberOfBought = self:GetNumberOfBought()
    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - numberOfBought > 0))
    self.item:SetActiveColor(numberOfBought < self.productConfig.stock)
end

function IapTilePackEventBundleLayout:GetEventExtraReward()
    local eventBirthdayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
    if eventBirthdayModel and eventBirthdayModel:IsOpening() then
        if self.productConfig.eventExtraRewardList:Count() == 0 and self.productConfig.isFree == false then
            self.productConfig.enableVipPointTag = true

            local dataId = eventBirthdayModel.timeData.dataId
            local bundleId = string.sub(self.productConfig.androidPackageName, string.len(self.productConfig.androidPackageName) - 25, string.len(self.productConfig.androidPackageName))
            --- @type EventBirthdayConfig
            local eventBirthdayConfig = ResourceMgr.GetEventConfig():GetData(EventTimeType.EVENT_BIRTHDAY, dataId)
            self.productConfig.eventExtraRewardList:Add(eventBirthdayConfig:GetMissionBundleBonusReward(dataId, bundleId))
        end
    else
        self.productConfig.eventExtraRewardList:Clear()
        self.productConfig.enableVipPointTag = false
    end
end

function IapTilePackEventBundleLayout:GetNumberOfBought()
    return self.iconData.numberOfBought
end

function IapTilePackEventBundleLayout:CheckAvailableAds()
    local numberOfBought = self:GetNumberOfBought()
    --- @type boolean
    self.availableAds = self.productConfig.numberWatchAds ~= nil and numberOfBought >= 1 and numberOfBought < self.productConfig.numberWatchAds + 1
end

function IapTilePackEventBundleLayout:WatchAds()
    VideoRewardedUtils.SetType(1)
    VideoRewardedUtils.SetAction(function()
        self:RequestBuy()
    end)
    IapDataInBound.Validate(function()
        if VideoRewardedUtils.AllowSkipVideo() then
            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "angel", 0)
            VideoRewardedUtils.RequestToServer()
        else
            VideoRewardedUtils.OpenRewarded(AdsPlacement.SHOP_DAILY_BUNDLE)
        end
    end)
end
