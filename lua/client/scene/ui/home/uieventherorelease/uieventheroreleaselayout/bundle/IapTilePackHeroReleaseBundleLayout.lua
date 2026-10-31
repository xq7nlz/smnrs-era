--- @class IapTilePackHeroReleaseBundleLayout : IapTilePackLayout
IapTilePackHeroReleaseBundleLayout = Class(IapTilePackHeroReleaseBundleLayout, IapTilePackLayout)

--- @param data ProductConfig
function IapTilePackHeroReleaseBundleLayout:InitData(data)
    self.productConfig = data
end

function IapTilePackHeroReleaseBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "event_bundle", self.packId)
end

function IapTilePackHeroReleaseBundleLayout:SetPackIcon()
    --- @type EventHeroReleaseModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HERO_RELEASE)
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconEventHeroReleaseBundle .. eventModel.timeData.dataId, self.packId)
    self.config.packIcon:SetNativeSize()
end

function IapTilePackHeroReleaseBundleLayout:OnClickBuy()
    if self.numberOfBought < self.productConfig.stock then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

function IapTilePackHeroReleaseBundleLayout:SetTextPrice()
    if self.productConfig.isFree ~= true then
        self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
    else
        self.config.textPrice.text = LanguageUtils.LocalizeCommon("free")
    end
end

function IapTilePackHeroReleaseBundleLayout:SetTextBuy()
    ---@type EventHeroReleaseModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HERO_RELEASE)
    self.numberOfBought = eventModel:GetNumberBuyOpCode(self.productConfig.opCode, self.productConfig.id)

    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock)
end

function IapTilePackHeroReleaseBundleLayout:GetBgTile()
    --- @type EventHeroReleaseModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HERO_RELEASE)
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconEventHeroReleaseBundle .. eventModel.timeData.dataId, self.packId)
    return self.packViewType .. "_" .. eventModel.timeData.dataId
end