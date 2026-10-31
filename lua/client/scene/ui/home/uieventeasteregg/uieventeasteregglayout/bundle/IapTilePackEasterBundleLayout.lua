require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackEasterBundleLayout : IapTilePackDailyLimitedLayout
IapTilePackEasterBundleLayout = Class(IapTilePackEasterBundleLayout, IapTilePackLayout)

--- @param data EventKazetsuBundleProduct
function IapTilePackEasterBundleLayout:InitData(data)
    --- @type EventKazetsuBundleProduct
    self.productConfig = data
end

function IapTilePackEasterBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "easter_bundle", self.packId)
end

function IapTilePackEasterBundleLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLimitedPackEasterBundle, self.packId)
    self.config.packIcon:SetNativeSize()
end

function IapTilePackEasterBundleLayout:SetTextBuy()
    ---@type EventEasterEggModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_EGG)
    self.numberOfBought = eventModel:GetNumberBuy(EventActionType.EASTER_BUNDLE_PURCHASE, self.productConfig.id)

    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock)
end

function IapTilePackEasterBundleLayout:OnClickBuy()
    if self.numberOfBought < self.productConfig.stock then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end