require "lua.client.scene.ui.home.uiEventLogin.UIEventLoginModel"
require "lua.client.scene.ui.home.uiEventLogin.UIEventLoginView"

--- @class UIEventLogin : UIBase
UIEventLogin = Class(UIEventLogin, UIBase)

--- @return void
function UIEventLogin:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventLogin:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventLoginModel()
	self.view = UIEventLoginView(self.model)
end

return UIEventLogin
