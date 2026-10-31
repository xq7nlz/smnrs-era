require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTileBlackFridayBundleLayout : IapTilePackDailyLimitedLayout
IapTileBlackFridayBundleLayout = Class(IapTileBlackFridayBundleLayout, IapTilePackLayout)

--- @param data EventBackFridayBundleProduct
function IapTileBlackFridayBundleLayout:InitData(data)
    --- @type EventBackFridayBundleProduct
    self.productConfig = data
end

function IapTileBlackFridayBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "black_friday_bundle", self.packId)
end

function IapTileBlackFridayBundleLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLimitedPackBlackFridayBundle, self.packId)
    self.config.packIcon:SetNativeSize()
end

function IapTileBlackFridayBundleLayout:SetTextBuy()
    ---@type EventEasterEggModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLACK_FRIDAY)
    self.numberOfBought = eventModel:GetNumberBuy(EventActionType.BLACK_FRIDAY_BUNDLE_PACK_BUY, self.productConfig.id)

    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock)
    self:UpdateProfitBonus()
end

function IapTileBlackFridayBundleLayout:OnClickBuy()
    if self.numberOfBought < self.productConfig.stock then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

function IapTileBlackFridayBundleLayout:UpdateProfitBonus()
    if self.productConfig.profitPercent ~= nil then
        self.config.hotProfit.gameObject:SetActive(true)
        self.config.profitText.text = tostring(self.productConfig.profitPercent) .. "%"
        self.config.extraText.text = LanguageUtils.LocalizeCommon("extra")
    end
end