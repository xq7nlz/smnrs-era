require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"
--- @class IapTilePackXmasLayout : IapTilePackDailyLimitedLayout
IapTilePackXmasLayout = Class(IapTilePackXmasLayout, IapTilePackDailyLimitedLayout)

--- @param data LimitedProduct
function IapTilePackXmasLayout:InitData(data)
    --- @type LimitedProduct
    self.productConfig = data
    ---@type EventXmasModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_XMAS)
    --- @type LimitedPackStatisticsInBound
    self.iconData = eventModel:GetLimitedPackStatisticsInBound(self.productConfig.id)
end

function IapTilePackXmasLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "daily_xmas", self.packId)
end

function IapTilePackXmasLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLimitedPackXmas, self.packId)
    self.config.packIcon:SetNativeSize()
end