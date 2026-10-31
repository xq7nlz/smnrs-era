require "lua.client.scene.ui.home.uiEventEasterDay.UIEventEasterDayModel"
require "lua.client.scene.ui.home.uiEventEasterDay.UIEventEasterDayView"

--- @class UIEventEasterDay : UIBase
UIEventEasterDay = Class(UIEventEasterDay, UIBase)

--- @return void
function UIEventEasterDay:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventEasterDay:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventEasterDayModel()
	self.view = UIEventEasterDayView(self.model)
end

return UIEventEasterDay
