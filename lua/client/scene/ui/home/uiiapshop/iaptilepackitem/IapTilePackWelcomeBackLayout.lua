require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackWelcomeBackLayout : IapTilePackLayout
IapTilePackWelcomeBackLayout = Class(IapTilePackWelcomeBackLayout, IapTilePackLayout)

--- @param data LimitedProduct
function IapTilePackWelcomeBackLayout:InitData(data)
    --- @type LimitedProduct
    self.productConfig = data

    --- @type WelcomeBackInBound
    self.welcomeBackInBound = zg.playerData:GetMethod(PlayerDataMethod.COMEBACK)
end

function IapTilePackWelcomeBackLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "welcome_back", self.packId)
end

function IapTilePackWelcomeBackLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconWelcomeBackBundle, self.packId)
    self.config.packIcon:SetNativeSize()
end

function IapTilePackWelcomeBackLayout:OnClickBuy()
    local numberBuy = self.welcomeBackInBound:GetNumberBuyPack(self.productConfig.id)
    if numberBuy < self.productConfig.stock then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

function IapTilePackWelcomeBackLayout:SetTextBuy()
    local numberBuy = self.welcomeBackInBound:GetNumberBuyPack(self.productConfig.id)

    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - numberBuy, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - numberBuy > 0))
    self.item:SetActiveColor(numberBuy < self.productConfig.stock)
end