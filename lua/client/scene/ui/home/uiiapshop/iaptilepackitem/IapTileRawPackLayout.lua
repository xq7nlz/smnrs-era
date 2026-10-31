--- @class IapTileRawPackLayout : IapTilePackLayout
IapTileRawPackLayout = Class(IapTileRawPackLayout, IapTilePackLayout)

--- @param data RawProduct
function IapTileRawPackLayout:InitData(data)
    --- @type RawProduct
    self.productConfig = data
end

function IapTileRawPackLayout:FireTrackingEvent()
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "raw_pack", self.packId)
end

function IapTileRawPackLayout:InitLocalization()
    self.config.text1stPurchase.text = LanguageUtils.LocalizeCommon("first_purchase")
end

function IapTileRawPackLayout:SetPackIcon()
    self.config.packIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconRawPack, self.packId)
    self.config.packIcon:SetNativeSize()
end

function IapTileRawPackLayout:SetTextBuy()
    IapTilePackLayout.SetTextBuy(self)
    self.config.textPurchaseLimit.text = ""
    self:UpdateViewBonus()
end

function IapTileRawPackLayout:UpdateViewBonus()
    if self.productConfig.bonusReward and self.productConfig:HasBought() == false then
        self.config.bonus1stPurchase:SetActive(true)
        self.config.textBonus.text = string.format("+%d", ClientMathUtils.ConvertingCalculation(self.productConfig.bonusReward.number))
    else
        self.config.bonus1stPurchase:SetActive(false)
    end
end