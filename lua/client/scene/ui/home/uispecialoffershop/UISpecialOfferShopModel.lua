
--- @class UISpecialOfferShopModel : UIBaseModel
UISpecialOfferShopModel = Class(UISpecialOfferShopModel, UIBaseModel)

--- @return void
function UISpecialOfferShopModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISpecialOfferShop, "special_offer_shop")

	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP

	self.bgDark = false
end

