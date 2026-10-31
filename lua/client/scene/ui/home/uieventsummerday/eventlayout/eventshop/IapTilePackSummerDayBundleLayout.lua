require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackSummerDayBundleLayout : IapTilePackLayout
IapTilePackSummerDayBundleLayout = Class(IapTilePackSummerDayBundleLayout, IapTilePackLayout)

local UNLIMIT = -1

--- @param data EventSummerDayProduct
function IapTilePackSummerDayBundleLayout:InitData(data)
    --- @type EventSummerDayProduct
    self.productConfig = data
end

function IapTilePackSummerDayBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "daily_summer_day", self.packId)
end

function IapTilePackSummerDayBundleLayout:SetPackIcon()
    self:EnablePackIcon(false)
end

function IapTilePackSummerDayBundleLayout:SetTextBuy()
    --- @type EventSummerDayModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SUMMER_DAY)
    self.numberOfBought = eventModel:GetNumberBuy(self.productConfig.id)
    self.config.textPurchaseLimit.gameObject:SetActive(not self.productConfig.stock == UNLIMIT)
    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT)
end

function IapTilePackSummerDayBundleLayout:OnClickBuy()
    if self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

