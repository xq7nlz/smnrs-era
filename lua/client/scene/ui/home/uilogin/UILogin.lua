require "lua.client.scene.ui.home.uiLogin.UILoginModel"
require "lua.client.scene.ui.home.uiLogin.UILoginView"

--- @class UILogin : UIBase
UILogin = Class(UILogin, UIBase)

--- @return void
function UILogin:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UILogin:OnCreate()
	UIBase.OnCreate(self)
	self.model = UILoginModel()
	self.view = UILoginView(self.model, self.ctrl)
end

return UILogin
