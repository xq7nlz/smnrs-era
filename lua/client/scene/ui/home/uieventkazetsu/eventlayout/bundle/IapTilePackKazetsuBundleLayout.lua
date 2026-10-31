require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackKazetsuBundleLayout : IapTilePackDailyLimitedLayout
IapTilePackKazetsuBundleLayout = Class(IapTilePackKazetsuBundleLayout, IapTilePackLayout)

--- @param data EventKazetsuBundleProduct
function IapTilePackKazetsuBundleLayout:InitData(data)
    --- @type EventKazetsuBundleProduct
    self.productConfig = data
    ---@type EventKazetsuModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
    --- @type LimitedPackStatisticsInBound
    self.iconData = eventModel:GetLimitedPackStatisticsInBound(self.productConfig.id)
end

function IapTilePackKazetsuBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "kazetsu_bundle", self.packId)
end

function IapTilePackKazetsuBundleLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLimitedPackKazetsuBundle, self.packId)
    self.config.packIcon:SetNativeSize()
end

function IapTilePackKazetsuBundleLayout:SetTextBuy()
    ---@type EventKazetsuModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
    self.numberOfBought = eventModel:GetNumberBuy(self.productConfig.id)

    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock)
end

function IapTilePackKazetsuBundleLayout:OnClickBuy()
    if self.numberOfBought < self.productConfig.stock then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end