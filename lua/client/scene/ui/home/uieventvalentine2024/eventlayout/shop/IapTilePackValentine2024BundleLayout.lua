require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

local BUY_SUCCESS = 1
local LIMIT_BUY = 0
local BUY_FAIL = 2

--- @class IapTilePackValentine2024BundleLayout : IapTilePackLayout
IapTilePackValentine2024BundleLayout = Class(IapTilePackValentine2024BundleLayout, IapTilePackLayout)

local UNLIMIT = -1

--- @param data EventValentine2024Product
function IapTilePackValentine2024BundleLayout:InitData(data)
    --- @type EventValentine2024Product
    self.productConfig = data
end

function IapTilePackValentine2024BundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "daily_valentine_2024", self.packId)
end

function IapTilePackValentine2024BundleLayout:SetPackIcon()
    self:EnablePackIcon(false)
end

function IapTilePackValentine2024BundleLayout:SetTextBuy()
    --- @type EventValentine2024Model
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_VALENTINE_2024)
    self.numberOfBought = eventModel:GetNumberBuy(self.productConfig.id)
    self.config.textPurchaseLimit.gameObject:SetActive(not self.productConfig.stock == UNLIMIT)
    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT)
end

function IapTilePackValentine2024BundleLayout:OnBuySuccess()
    TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_VALENTINE_2024, self.productConfig.androidPackageName, BUY_SUCCESS)
    self:SetTextBuy()
    self:SetTextPrice()
    if self.buySuccessListener then
        self.buySuccessListener()
    end
end

function IapTilePackValentine2024BundleLayout:OnBuyFail()
    TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_VALENTINE_2024, self.productConfig.androidPackageName, BUY_FAIL)
end

function IapTilePackValentine2024BundleLayout:OnClickBuy()
    if self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT then
        self:RequestBuy()
    else
        TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_VALENTINE_2024, self.productConfig.androidPackageName, LIMIT_BUY)
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

