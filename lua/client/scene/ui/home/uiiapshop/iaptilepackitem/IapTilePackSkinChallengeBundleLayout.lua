require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackSkinChallengeBundleLayout : IapTilePackLayout
IapTilePackSkinChallengeBundleLayout = Class(IapTilePackSkinChallengeBundleLayout, IapTilePackLayout)

--- @param data EventBackFridayBundleProduct
function IapTilePackSkinChallengeBundleLayout:InitData(data)
    --- @type EventBackFridayBundleProduct
    self.productConfig = data
end

function IapTilePackSkinChallengeBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "event_skin_challenge", self.packId)
end

function IapTilePackSkinChallengeBundleLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLimitedPackBlackFridayBundle, self.packId)
    self.config.packIcon:SetNativeSize()
end

function IapTilePackSkinChallengeBundleLayout:SetTextBuy()
    ---@type EventSkinChallengeModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SKIN_CHALLENGE)
    self.numberOfBought = eventModel:GetNumberBuy(EventActionType.SKIN_CHALLENGE_BUNDLE, self.productConfig.id)
    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock)
end

function IapTilePackSkinChallengeBundleLayout:OnClickBuy()
    if self.numberOfBought < self.productConfig.stock then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end