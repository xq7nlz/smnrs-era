--- @class IapTilePackNewHeroBundleLayout : IapTilePackLayout
IapTilePackNewHeroBundleLayout = Class(IapTilePackNewHeroBundleLayout, IapTilePackLayout)

--- @param data PurchasedPackInBound
function IapTilePackNewHeroBundleLayout:InitData(data)
    --- @type PurchasedPackInBound
    self.iconData = data
    self.productConfig = data.config
end

function IapTilePackNewHeroBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "event_bundle", self.packId)
end

function IapTilePackNewHeroBundleLayout:SetPackIcon()
    --- @type EventNewHeroBundleModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_BUNDLE)
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconEventNewHeroBundle .. eventModel.timeData.dataId, self.packId)
    self.config.packIcon:SetNativeSize()
end

function IapTilePackNewHeroBundleLayout:OnClickBuy()
    if self.iconData.numberOfBought < self.productConfig.stock then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

function IapTilePackNewHeroBundleLayout:SetTextPrice()
    if self.productConfig.isFree ~= true then
        self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
    else
        self.config.textPrice.text = LanguageUtils.LocalizeCommon("free")
    end
end

function IapTilePackNewHeroBundleLayout:SetTextBuy()
    --local color = UIUtils.green_dark
    --if self.productConfig.stock - self.iconData.numberOfBought == 0 then
    --    color = UIUtils.white
    --end
    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.iconData.numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.iconData.numberOfBought > 0))
    self.item:SetActiveColor(self.iconData.numberOfBought < self.productConfig.stock)
end

function IapTilePackNewHeroBundleLayout:GetBgTile()
    --- @type EventNewHeroBundleModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_BUNDLE)
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconEventNewHeroBundle .. eventModel.timeData.dataId, self.packId)
    return self.packViewType .. "_" .. eventModel.timeData.dataId
end