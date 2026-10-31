require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

local BUY_SUCCESS = 1
local LIMIT_BUY = 0
local BUY_FAIL = 2

--- @class IapTilePackQixiFestivalBundleLayout : IapTilePackLayout
IapTilePackQixiFestivalBundleLayout = Class(IapTilePackQixiFestivalBundleLayout, IapTilePackLayout)

local UNLIMIT = -1

--- @param data EventNewYear2023Product
function IapTilePackQixiFestivalBundleLayout:InitData(data)
    --- @type EventNewYear2023Product
    self.productConfig = data
end

function IapTilePackQixiFestivalBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "daily_qixi_festival", self.packId)
end

function IapTilePackQixiFestivalBundleLayout:SetPackIcon()
    self:EnablePackIcon(false)
end

function IapTilePackQixiFestivalBundleLayout:SetTextBuy()
    --- @type EventQixiFestivalModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_QIXI)
    self.numberOfBought = eventModel:GetNumberBuy(self.productConfig.id)
    self.config.textPurchaseLimit.gameObject:SetActive(not self.productConfig.stock == UNLIMIT)
    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT)
end

function IapTilePackQixiFestivalBundleLayout:OnBuySuccess()
    TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_QIXI_FESTIVAL, self.productConfig.androidPackageName, BUY_SUCCESS)
    self:SetTextBuy()
    self:SetTextPrice()
    if self.buySuccessListener then
        self.buySuccessListener()
    end
end

function IapTilePackQixiFestivalBundleLayout:OnBuyFail()
    TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_QIXI_FESTIVAL, self.productConfig.androidPackageName, BUY_FAIL)
end

function IapTilePackQixiFestivalBundleLayout:OnClickBuy()
    if self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT then
        self:RequestBuy()
    else
        TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_QIXI_FESTIVAL, self.productConfig.androidPackageName, LIMIT_BUY)
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

