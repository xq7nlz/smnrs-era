require "lua.client.scene.ui.home.uiFanpageNavigator.UIFanpageNavigatorModel"
require "lua.client.scene.ui.home.uiFanpageNavigator.UIFanpageNavigatorView"

--- @class UIFanpageNavigator : UIBase
UIFanpageNavigator = Class(UIFanpageNavigator, UIBase)

--- @return void
function UIFanpageNavigator:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFanpageNavigator:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFanpageNavigatorModel()
	self.view = UIFanpageNavigatorView(self.model, self.ctrl)
end

return UIFanpageNavigator
