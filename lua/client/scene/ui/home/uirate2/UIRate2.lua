require "lua.client.scene.ui.home.uiRate2.UIRate2Model"
require "lua.client.scene.ui.home.uiRate2.UIRate2View"
require "lua.client.scene.ui.home.uiRate.UIRateView"
require "lua.client.scene.ui.home.uiRate.UIRate"
--- @class UIRate2 : UIRate
UIRate2 = Class(UIRate2, UIRate)

--- @return void
function UIRate2:Ctor()
	UIRate.Ctor(self)
end

--- @return void
function UIRate2:OnCreate()
	UIRate.OnCreate(self)
	self.model = UIRate2Model()
	self.view = UIRate2View(self.model)
end

return UIRate2
