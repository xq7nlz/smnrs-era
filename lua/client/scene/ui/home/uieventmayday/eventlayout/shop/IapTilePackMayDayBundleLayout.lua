require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

local BUY_SUCCESS = 1
local LIMIT_BUY = 0
local BUY_FAIL = 2

--- @class IapTilePackMayDayBundleLayout : IapTilePackLayout
IapTilePackMayDayBundleLayout = Class(IapTilePackMayDayBundleLayout, IapTilePackLayout)

local UNLIMIT = -1

--- @param data EventMayDayProduct
function IapTilePackMayDayBundleLayout:InitData(data)
    --- @type EventMayDayProduct
    self.productConfig = data
end

function IapTilePackMayDayBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "daily_may_day", self.packId)
end

function IapTilePackMayDayBundleLayout:SetPackIcon()
    self:EnablePackIcon(false)
end

function IapTilePackMayDayBundleLayout:SetTextBuy()
    --- @type EventMayDayModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MAY_DAY)
    self.numberOfBought = eventModel:GetNumberBuy(self.productConfig.id)
    self.config.textPurchaseLimit.gameObject:SetActive(not self.productConfig.stock == UNLIMIT)
    self.config.rewardAnchor.localPosition = U_Vector3(0,20,0)
    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT)
end

function IapTilePackMayDayBundleLayout:OnBuySuccess()
    TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_MAY_DAY, self.productConfig.androidPackageName, BUY_SUCCESS)
    self:SetTextBuy()
    self:SetTextPrice()
    if self.buySuccessListener then
        self.buySuccessListener()
    end
end

function IapTilePackMayDayBundleLayout:OnBuyFail()
    TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_MAY_DAY, self.productConfig.androidPackageName, BUY_FAIL)
end

function IapTilePackMayDayBundleLayout:OnClickBuy()
    if self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT then
        self:RequestBuy()
    else
        TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_MAY_DAY, self.productConfig.androidPackageName, LIMIT_BUY)
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

