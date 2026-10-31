require "lua.client.scene.ui.home.uiEventSummerDay.UIEventSummerDayModel"
require "lua.client.scene.ui.home.uiEventSummerDay.UIEventSummerDayView"

--- @class UIEventSummerDay : UIBase
UIEventSummerDay = Class(UIEventSummerDay, UIBase)

--- @return void
function UIEventSummerDay:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventSummerDay:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventSummerDayModel()
	self.view = UIEventSummerDayView(self.model)
end

return UIEventSummerDay
