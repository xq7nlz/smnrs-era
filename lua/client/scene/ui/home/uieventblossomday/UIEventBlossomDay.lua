require "lua.client.scene.ui.home.uiEventBlossomDay.UIEventBlossomDayModel"
require "lua.client.scene.ui.home.uiEventBlossomDay.UIEventBlossomDayView"

--- @class UIEventBlossomDay : UIBase
UIEventBlossomDay = Class(UIEventBlossomDay, UIBase)

--- @return void
function UIEventBlossomDay:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventBlossomDay:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventBlossomDayModel()
	self.view = UIEventBlossomDayView(self.model)
end

return UIEventBlossomDay
