require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

local BUY_SUCCESS = 1
local LIMIT_BUY = 0
local BUY_FAIL = 2

--- @class IapTilePackBlossomDayBundleLayout : IapTilePackLayout
IapTilePackBlossomDayBundleLayout = Class(IapTilePackBlossomDayBundleLayout, IapTilePackLayout)

local UNLIMIT = -1

--- @param data EventNewYear2023Product
function IapTilePackBlossomDayBundleLayout:InitData(data)
    --- @type EventNewYear2023Product
    self.productConfig = data
end

function IapTilePackBlossomDayBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "daily_blossom_day", self.packId)
end

function IapTilePackBlossomDayBundleLayout:SetPackIcon()
    self:EnablePackIcon(false)
end

function IapTilePackBlossomDayBundleLayout:SetTextBuy()
    --- @type EventNewYear2023Model
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLOSSOM)
    self.numberOfBought = eventModel:GetNumberBuy(self.productConfig.id)
    self.config.textPurchaseLimit.gameObject:SetActive(not self.productConfig.stock == UNLIMIT)
    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT)
end

function IapTilePackBlossomDayBundleLayout:OnBuySuccess()
    TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_BLOSSOM, self.productConfig.androidPackageName, BUY_SUCCESS)
    self:SetTextBuy()
    self:SetTextPrice()
    if self.buySuccessListener then
        self.buySuccessListener()
    end
end

function IapTilePackBlossomDayBundleLayout:OnBuyFail()
    TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_BLOSSOM, self.productConfig.androidPackageName, BUY_FAIL)
end

function IapTilePackBlossomDayBundleLayout:OnClickBuy()
    if self.numberOfBought < self.productConfig.stock or self.productConfig.stock == UNLIMIT then
        self:RequestBuy()
    else
        TrackingUtils.AddFireBasePurchaseClickEvent(FBEvents.EVENT_BLOSSOM, self.productConfig.androidPackageName, LIMIT_BUY)
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

