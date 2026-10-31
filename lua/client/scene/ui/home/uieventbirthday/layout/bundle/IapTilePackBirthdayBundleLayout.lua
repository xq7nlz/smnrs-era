require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackBirthdayBundleLayout : IapTilePackDailyLimitedLayout
IapTilePackBirthdayBundleLayout = Class(IapTilePackBirthdayBundleLayout, IapTilePackLayout)

--- @param data BirthdayBundleProduct
function IapTilePackBirthdayBundleLayout:InitData(data)
    --- @type BirthdayBundleProduct
    self.productConfig = data
end

function IapTilePackBirthdayBundleLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "birthday_bundle", self.packId)
end

function IapTilePackBirthdayBundleLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLimitedPackBirthday, self.packId)
    self.config.packIcon:SetNativeSize()
end

function IapTilePackBirthdayBundleLayout:SetTextBuy()
    ---@type EventBirthdayModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
    self.numberOfBought = eventModel:GetNumberBuy(EventActionType.BIRTHDAY_BUNDLE_PURCHASE,self.productConfig.id)

    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.numberOfBought, self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.numberOfBought > 0))
    self.item:SetActiveColor(self.numberOfBought < self.productConfig.stock)
end

function IapTilePackBirthdayBundleLayout:OnClickBuy()
    if self.numberOfBought < self.productConfig.stock then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end