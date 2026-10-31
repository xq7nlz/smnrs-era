require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackSkinBundleLayout : IapTilePackLayout
IapTilePackSkinBundleLayout = Class(IapTilePackSkinBundleLayout, IapTilePackLayout)

--- @param data ProductConfig
function IapTilePackSkinBundleLayout:InitData(data)
    --- @type ProductConfig
    self.productConfig = data

    --- @type EventPopupModel
    self.eventPopupModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SKIN_BUNDLE)
end

function IapTilePackSkinBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "skin_bundle", self.packId)
end

function IapTilePackSkinBundleLayout:SetPackIcon()
    --self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconWelcomeBackBundle, self.packId)
    --self.config.packIcon:SetNativeSize()
end

function IapTilePackSkinBundleLayout:OnClickBuy()
    local numberBuy = self.eventPopupModel:GetNumberBuyOpCode(self.productConfig.opCode, self.productConfig.id)
    if numberBuy < self.productConfig.stock then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

function IapTilePackSkinBundleLayout:SetTextBuy()
    local numberBuy = self.eventPopupModel:GetNumberBuyOpCode(self.productConfig.opCode, self.productConfig.id)

    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - numberBuy, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - numberBuy > 0))
    self.item:SetActiveColor(numberBuy < self.productConfig.stock)
end