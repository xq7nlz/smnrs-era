require "lua.client.scene.ui.home.uiEventQixiFestival.UIEventQixiFestivalModel"
require "lua.client.scene.ui.home.uiEventQixiFestival.UIEventQixiFestivalView"

--- @class UIEventQixiFestival : UIBase
UIEventQixiFestival = Class(UIEventQixiFestival, UIBase)

--- @return void
function UIEventQixiFestival:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventQixiFestival:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventQixiFestivalModel()
	self.view = UIEventQixiFestivalView(self.model)
end

return UIEventQixiFestival
