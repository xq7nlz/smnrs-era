require "lua.client.scene.ui.home.uiEventMayDay.UIEventMayDayModel"
require "lua.client.scene.ui.home.uiEventMayDay.UIEventMayDayView"

--- @class UIEventMayDay : UIBase
UIEventMayDay = Class(UIEventMayDay, UIBase)

--- @return void
function UIEventMayDay:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventMayDay:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventMayDayModel()
	self.view = UIEventMayDayView(self.model)
end

return UIEventMayDay
