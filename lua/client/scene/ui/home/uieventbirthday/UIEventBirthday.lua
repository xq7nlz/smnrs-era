require "lua.client.scene.ui.home.uiEventBirthday.UIEventBirthdayModel"
require "lua.client.scene.ui.home.uiEventBirthday.UIEventBirthdayView"

--- @class UIEventBirthday : UIBase
UIEventBirthday = Class(UIEventBirthday, UIBase)

--- @return void
function UIEventBirthday:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventBirthday:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventBirthdayModel()
	self.view = UIEventBirthdayView(self.model)
end

return UIEventBirthday
