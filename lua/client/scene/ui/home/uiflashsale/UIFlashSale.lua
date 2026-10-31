require "lua.client.scene.ui.home.uiFlashSale.UIFlashSaleModel"
require "lua.client.scene.ui.home.uiFlashSale.UIFlashSaleView"

--- @class UIFlashSale : UIBase
UIFlashSale = Class(UIFlashSale, UIBase)

--- @return void
function UIFlashSale:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFlashSale:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFlashSaleModel()
	self.view = UIFlashSaleView(self.model)
end

return UIFlashSale
