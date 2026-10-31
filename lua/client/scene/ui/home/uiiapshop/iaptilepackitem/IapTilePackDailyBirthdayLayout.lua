require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackDailyBirthdayLayout : IapTilePackDailyLimitedLayout
IapTilePackDailyBirthdayLayout = Class(IapTilePackDailyBirthdayLayout, IapTilePackDailyLimitedLayout)

--- @param data LimitedProduct
function IapTilePackDailyBirthdayLayout:InitData(data)
    --- @type LimitedProduct
    self.productConfig = data
    ---@type EventBirthdayModel
    local eventBirthdayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
    --- @type LimitedPackStatisticsInBound
    self.iconData = eventBirthdayModel:GetLimitedPackStatisticsInBound(self.productConfig.id)
end

function IapTilePackDailyBirthdayLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "birthday", self.packId)
end

function IapTilePackDailyBirthdayLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLimitedPackBirthday, self.packId)
    self.config.packIcon:SetNativeSize()
end