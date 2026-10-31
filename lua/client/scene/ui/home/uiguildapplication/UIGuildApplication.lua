require "lua.client.scene.ui.home.uiGuildApplication.UIGuildApplicationModel"
require "lua.client.scene.ui.home.uiGuildApplication.UIGuildApplicationView"

--- @class UIGuildApplication : UIBase
UIGuildApplication = Class(UIGuildApplication, UIBase)

--- @return void
function UIGuildApplication:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildApplication:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildApplicationModel()
	self.view = UIGuildApplicationView(self.model, self.ctrl)
end

return UIGuildApplication
