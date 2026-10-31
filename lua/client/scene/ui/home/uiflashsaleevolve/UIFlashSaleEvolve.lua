require "lua.client.scene.ui.home.uiFlashSaleEvolve.UIFlashSaleEvolveModel"
require "lua.client.scene.ui.home.uiFlashSaleEvolve.UIFlashSaleEvolveView"

--- @class UIFlashSaleEvolve : UIBase
UIFlashSaleEvolve = Class(UIFlashSaleEvolve, UIBase)

--- @return void
function UIFlashSaleEvolve:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFlashSaleEvolve:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFlashSaleEvolveModel()
	self.view = UIFlashSaleEvolveView(self.model)
end

return UIFlashSaleEvolve
