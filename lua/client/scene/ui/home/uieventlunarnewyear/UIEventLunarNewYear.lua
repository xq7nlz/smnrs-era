require "lua.client.scene.ui.home.uiEventLunarNewYear.UIEventLunarNewYearModel"
require "lua.client.scene.ui.home.uiEventLunarNewYear.UIEventLunarNewYearView"

--- @class UIEventLunarNewYear : UIBase
UIEventLunarNewYear = Class(UIEventLunarNewYear, UIBase)

--- @return void
function UIEventLunarNewYear:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventLunarNewYear:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventLunarNewYearModel()
	self.view = UIEventLunarNewYearView(self.model, self.ctrl)
end

return UIEventLunarNewYear
