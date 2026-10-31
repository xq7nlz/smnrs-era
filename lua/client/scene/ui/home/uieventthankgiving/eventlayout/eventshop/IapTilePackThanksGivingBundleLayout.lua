require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackThanksGivingBundleLayout : IapTilePackLayout
IapTilePackThanksGivingBundleLayout = Class(IapTilePackThanksGivingBundleLayout, IapTilePackLayout)

local UNLIMIT = -1

--- @param data EventThanksGivingProduct
function IapTilePackThanksGivingBundleLayout:InitData(data)
    --- @type EventThanksGivingProduct
    self.productConfig = data
end

function IapTilePackThanksGivingBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "daily_thanks_giving", self.packId)
end

function IapTilePackThanksGivingBundleLayout:SetPackIcon()
    self:EnablePackIcon(false)
end

function IapTilePackThanksGivingBundleLayout:SetTextBuy()
    --- @type EventMidAutumnModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_THANKS_GIVING)
    self.numberOfBought = eventModel:GetNumberBuy(self.productConfig.id)
    self.config.textPurchaseLimit.gameObject:SetActive(not self.productConfig.stock == UNLIMIT)
    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT)
end

function IapTilePackThanksGivingBundleLayout:OnClickBuy()
    if self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

