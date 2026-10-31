require "lua.client.scene.ui.home.uiGuildWarRegistration.UIGuildWarRegistrationModel"
require "lua.client.scene.ui.home.uiGuildWarRegistration.UIGuildWarRegistrationView"

--- @class UIGuildWarRegistration : UIBase
UIGuildWarRegistration = Class(UIGuildWarRegistration, UIBase)

--- @return void
function UIGuildWarRegistration:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildWarRegistration:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildWarRegistrationModel()
	self.view = UIGuildWarRegistrationView(self.model)
end

return UIGuildWarRegistration
