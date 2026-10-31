require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackEasterDayBundleLayout : IapTilePackLayout
IapTilePackEasterDayBundleLayout = Class(IapTilePackEasterDayBundleLayout, IapTilePackLayout)

local UNLIMIT = -1

--- @param data EventEasterDayProduct
function IapTilePackEasterDayBundleLayout:InitData(data)
    --- @type EventEasterDayProduct
    self.productConfig = data
end

function IapTilePackEasterDayBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "daily_easter_day", self.packId)
end

function IapTilePackEasterDayBundleLayout:SetPackIcon()
    self:EnablePackIcon(false)
end

function IapTilePackEasterDayBundleLayout:SetTextBuy()
    --- @type EventEasterDayModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_DAY)
    self.numberOfBought = eventModel:GetNumberBuy(self.productConfig.id)
    self.config.textPurchaseLimit.gameObject:SetActive(not self.productConfig.stock == UNLIMIT)
    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT)
end

function IapTilePackEasterDayBundleLayout:OnClickBuy()
    if self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

