require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackValentineBundleLayout : IapTilePackDailyLimitedLayout
IapTilePackValentineBundleLayout = Class(IapTilePackValentineBundleLayout, IapTilePackDailyLimitedLayout)

--- @param data LimitedProduct
function IapTilePackValentineBundleLayout:InitData(data)
    --- @type LimitedProduct
    self.productConfig = data
    ---@type EventValentineModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_VALENTINE)
    --- @type LimitedPackStatisticsInBound
    self.iconData = self.eventModel:GetLimitedPackStatisticsInBound(self.productConfig.id)
end

function IapTilePackValentineBundleLayout:SetTextBuy()
    self.numberOfBought = self.eventModel:GetNumberBuy(self.productConfig.id)
    self.config.textPurchaseLimit.text = string.format("%s %s",
            UIUtils.SetColorString(UIUtils.pink1, LanguageUtils.LocalizeCommon("limited_packs")),
            UIUtils.SetColorString(UIUtils.purple1, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))
    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock)
end

function IapTilePackValentineBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "valentine_bundle", self.packId)
end

function IapTilePackValentineBundleLayout:OnClickBuy()
    if self.eventModel:GetNumberBuy(self.productConfig.id) < self.productConfig.stock then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

function IapTilePackValentineBundleLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLimitedPackValentineBundle, self.packId)
    self.config.packIcon:SetNativeSize()
end