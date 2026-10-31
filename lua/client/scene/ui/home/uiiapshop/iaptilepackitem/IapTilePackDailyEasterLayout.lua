require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackDailyEasterLayout : IapTilePackDailyLimitedLayout
IapTilePackDailyEasterLayout = Class(IapTilePackDailyEasterLayout, IapTilePackDailyLimitedLayout)

--- @param data LimitedProduct
function IapTilePackDailyEasterLayout:InitData(data)
    --- @type LimitedProduct
    self.productConfig = data
    ---@type EventEasterEggModel
    local easterEggModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_EGG)
    --- @type LimitedPackStatisticsInBound
    self.iconData = easterEggModel:GetLimitedPackStatisticsInBound(self.productConfig.id)
end

function IapTilePackDailyEasterLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "daily_easter_egg", self.packId)
end

function IapTilePackDailyEasterLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLimitedPackEasterEgg, self.packId)
    self.config.packIcon:SetNativeSize()
end