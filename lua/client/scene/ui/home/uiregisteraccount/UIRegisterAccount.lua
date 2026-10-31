require "lua.client.scene.ui.home.uiRegisterAccount.UIRegisterAccountModel"
require "lua.client.scene.ui.home.uiRegisterAccount.UIRegisterAccountView"

--- @class UIRegisterAccount : UIBase
UIRegisterAccount = Class(UIRegisterAccount, UIBase)

--- @return void
function UIRegisterAccount:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIRegisterAccount:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIRegisterAccountModel()
	self.view = UIRegisterAccountView(self.model, self.ctrl)
end

return UIRegisterAccount
