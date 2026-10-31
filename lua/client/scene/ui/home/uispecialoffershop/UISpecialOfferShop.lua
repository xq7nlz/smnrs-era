require "lua.client.scene.ui.home.uiSpecialOfferShop.UISpecialOfferShopModel"
require "lua.client.scene.ui.home.uiSpecialOfferShop.UISpecialOfferShopView"

--- @class UISpecialOfferShop : UIBase
UISpecialOfferShop = Class(UISpecialOfferShop, UIBase)

--- @return void
function UISpecialOfferShop:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISpecialOfferShop:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISpecialOfferShopModel()
	self.view = UISpecialOfferShopView(self.model)
end

return UISpecialOfferShop
