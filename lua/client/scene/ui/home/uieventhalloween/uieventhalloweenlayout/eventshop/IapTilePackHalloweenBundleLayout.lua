require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackHalloweenBundleLayout : IapTilePackLayout
IapTilePackHalloweenBundleLayout = Class(IapTilePackHalloweenBundleLayout, IapTilePackLayout)

local UNLIMIT = -1

--- @param data EventHalloweenProduct
function IapTilePackHalloweenBundleLayout:InitData(data)
    --- @type EventHalloweenProduct
    self.productConfig = data
end

function IapTilePackHalloweenBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "daily_halloween", self.packId)
end

function IapTilePackHalloweenBundleLayout:SetPackIcon()
    self:EnablePackIcon(false)
end

function IapTilePackHalloweenBundleLayout:SetTextBuy()
    --- @type EventMidAutumnModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HALLOWEEN)
    self.numberOfBought = eventModel:GetNumberBuy(self.productConfig.id)
    self.config.textPurchaseLimit.gameObject:SetActive(not self.productConfig.stock == UNLIMIT)
    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT)
end

function IapTilePackHalloweenBundleLayout:OnClickBuy()
    if self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

