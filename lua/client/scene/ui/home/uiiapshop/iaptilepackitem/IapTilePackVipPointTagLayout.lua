--- @class IapTilePackVipPointTagLayout : IapTilePackLayout
IapTilePackVipPointTagLayout = Class(IapTilePackVipPointTagLayout, IapTilePackLayout)

--- @param data LimitedProduct
function IapTilePackVipPointTagLayout:InitData(data)
    --- @type LimitedProduct
    self.productConfig = data
    --- @type LimitedPackStatisticsInBound
    self.iconData = zg.playerData:GetIAP():GetLimitedPackStatisticsInBound(data.id)
end

function IapTilePackVipPointTagLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "daily_limited", self.packId)
end

--- @return void
--- Get pack icon/banner icon from atlas then show it out
function IapTilePackVipPointTagLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLimitedPackLunarNewYear2022, self.packId)
    self.config.packIcon:SetNativeSize()
end

--- @return void
--- Set reward list icon and add & show vip point value to vip point tag
function IapTilePackVipPointTagLayout:SetReward()
end

--- @return void
--- Call back on click buy button
function IapTilePackVipPointTagLayout:OnClickBuy()
    --- Send request purchase if amout of bought not reach limit
    if self.iconData:GetNumberOfBought() < self.productConfig.stock then
        self:RequestBuy()
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

function IapTilePackVipPointTagLayout:SetTextBuy()
    self.config.textPurchaseLimit.text = string.format("%s %s",
            LanguageUtils.LocalizeCommon("limited_packs"),
            UIUtils.SetColorString(UIUtils.white, string.format("%s/%s", self.productConfig.stock - self.iconData:GetNumberOfBought(), self.productConfig.stock)))

    self.item:EnableNotification(self.productConfig.isFree == true and (self.productConfig.stock - self.iconData:GetNumberOfBought() > 0))
    self.item:SetActiveColor(self.iconData:GetNumberOfBought() < self.productConfig.stock)
end

function IapTilePackVipPointTagLayout:OnHide()
    IapTilePackLayout.OnHide(self)
    self.config.vip:SetActive(false)
end