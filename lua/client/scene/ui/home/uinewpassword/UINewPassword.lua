require "lua.client.scene.ui.home.uiNewPassword.UINewPasswordModel"
require "lua.client.scene.ui.home.uiNewPassword.UINewPasswordView"

--- @class UINewPassword : UIBase
UINewPassword = Class(UINewPassword, UIBase)

--- @return void
function UINewPassword:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UINewPassword:OnCreate()
	UIBase.OnCreate(self)
	self.model = UINewPasswordModel()
	self.view = UINewPasswordView(self.model, self.ctrl)
end

return UINewPassword
