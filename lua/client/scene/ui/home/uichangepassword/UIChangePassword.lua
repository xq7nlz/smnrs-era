require "lua.client.scene.ui.home.uiChangePassword.UIChangePasswordModel"
require "lua.client.scene.ui.home.uiChangePassword.UIChangePasswordView"

--- @class UIChangePassword : UIBase
UIChangePassword = Class(UIChangePassword, UIBase)

--- @return void
function UIChangePassword:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIChangePassword:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIChangePasswordModel()
	self.view = UIChangePasswordView(self.model, self.ctrl)
end

return UIChangePassword
