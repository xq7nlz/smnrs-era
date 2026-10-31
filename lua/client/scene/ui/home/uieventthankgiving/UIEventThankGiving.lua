require "lua.client.scene.ui.home.uiEventThankGiving.UIEventThankGivingModel"
require "lua.client.scene.ui.home.uiEventThankGiving.UIEventThankGivingView"

--- @class UIEventThankGiving : UIBase
UIEventThankGiving = Class(UIEventThankGiving, UIBase)

--- @return void
function UIEventThankGiving:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventThankGiving:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventThankGivingModel()
	self.view = UIEventThankGivingView(self.model)
end

return UIEventThankGiving
