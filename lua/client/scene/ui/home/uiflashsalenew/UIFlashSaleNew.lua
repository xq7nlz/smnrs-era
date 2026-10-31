require "lua.client.scene.ui.home.uiFlashSaleNew.UIFlashSaleNewModel"
require "lua.client.scene.ui.home.uiFlashSaleNew.UIFlashSaleNewView"

--- @class UIFlashSaleNew : UIBase
UIFlashSaleNew = Class(UIFlashSaleNew, UIBase)

--- @return void
function UIFlashSaleNew:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFlashSaleNew:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFlashSaleNewModel()
	self.view = UIFlashSaleNewView(self.model)
end

return UIFlashSaleNew
