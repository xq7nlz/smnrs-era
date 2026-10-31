require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackMidAutumnBundleLayout : IapTilePackLayout
IapTilePackMidAutumnBundleLayout = Class(IapTilePackMidAutumnBundleLayout, IapTilePackLayout)

local UNLIMIT = -1

--- @param data EventMidAutumnProduct
function IapTilePackMidAutumnBundleLayout:InitData(data)
    --- @type EventMidAutumnProduct
    self.productConfig = data
end

function IapTilePackMidAutumnBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "mid_autumn_market", self.packId)
end

function IapTilePackMidAutumnBundleLayout:SetPackIcon()
    self:EnablePackIcon(false)
end

function IapTilePackMidAutumnBundleLayout:SetTextBuy()
    --- @type EventMidAutumnModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MID_AUTUMN)
    self.numberOfBought = eventModel:GetNumberBuy(self.productConfig.id)
    self.config.textPurchaseLimit.gameObject:SetActive(not self.productConfig.stock == UNLIMIT)
    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT)
end

function IapTilePackMidAutumnBundleLayout:OnClickBuy()
    if self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

