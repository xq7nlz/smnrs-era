require "lua.client.scene.ui.home.uiRate.UIRateModel"
require "lua.client.scene.ui.home.uiRate.UIRateView"

--- @class UIRate : UIBase
UIRate = Class(UIRate, UIBase)

--- @return void
function UIRate:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIRate:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIRateModel()
	self.view = UIRateView(self.model)
end

return UIRate
