require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"
--- @class IapTilePackHalloweenLayout : IapTilePackDailyLimitedLayout
IapTilePackHalloweenLayout = Class(IapTilePackHalloweenLayout, IapTilePackDailyLimitedLayout)

--- @param data LimitedProduct
function IapTilePackHalloweenLayout:InitData(data)
    --- @type LimitedProduct
    self.productConfig = data
    ---@type EventHalloweenModel
    local eventHalloweenModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HALLOWEEN)
    --- @type LimitedPackStatisticsInBound
    self.iconData = eventHalloweenModel:GetLimitedPackStatisticsInBound(self.productConfig.id)
end

function IapTilePackHalloweenLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "daily_halloween", self.packId)
end

function IapTilePackHalloweenLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLimitedPackHalloween, self.packId)
    self.config.packIcon:SetNativeSize()
end