--- @class UISpecialOfferLayout
UISpecialOfferLayout = Class(UISpecialOfferLayout)

--- @param view UISpecialOfferShopView
--- @param packViewType PackViewType
function UISpecialOfferLayout:Ctor(view, packViewType)
    --- @type UISpecialOfferShopView
    self.view = view
    --- @type UISpecialOfferShopConfig
    self.config = view.config
    --- @type PackViewType
    self.packViewType = packViewType
end

function UISpecialOfferLayout:InitLocalization()

end

function UISpecialOfferLayout:OnShow()
    --- @type IapDataInBound
    self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    --- @type List
    self.listGroupProductConfig = self.iapDataInBound.progressPackData:GetListActiveGroupByViewType(self.packViewType)
end

function UISpecialOfferLayout:SetUpLayout()

end

function UISpecialOfferLayout:OnHide()

end

function UISpecialOfferLayout:OnDestroy()

end