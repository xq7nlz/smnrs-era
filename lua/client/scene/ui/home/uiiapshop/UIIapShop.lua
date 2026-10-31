require "lua.client.scene.ui.home.uiIapShop.UIIapShopModel"
require "lua.client.scene.ui.home.uiIapShop.UIIapShopView"

--- @class UIIapShop : UIBase
UIIapShop = Class(UIIapShop, UIBase)

--- @return void
function UIIapShop:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIIapShop:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIIapShopModel()
	self.view = UIIapShopView(self.model)
end

return UIIapShop
