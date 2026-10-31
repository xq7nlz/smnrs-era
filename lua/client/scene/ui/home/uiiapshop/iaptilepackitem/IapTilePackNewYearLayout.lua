require "lua.client.scene.ui.home.uiIapShop.iapTilePackItem.IapTilePackDailyLimitedLayout"

--- @class IapTilePackNewYearLayout : IapTilePackDailyLimitedLayout
IapTilePackNewYearLayout = Class(IapTilePackNewYearLayout, IapTilePackDailyLimitedLayout)

--- @param data LimitedProduct
function IapTilePackNewYearLayout:InitData(data)
    --- @type LimitedProduct
    self.productConfig = data
    ---@type EventNewYearModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_YEAR)
    --- @type LimitedPackStatisticsInBound
    self.iconData = eventModel:GetLimitedPackStatisticsInBound(self.productConfig.id)
end

function IapTilePackNewYearLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "new_year", self.packId)
end

function IapTilePackNewYearLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLimitedPackNewYear, self.packId)
    self.config.packIcon:SetNativeSize()
end