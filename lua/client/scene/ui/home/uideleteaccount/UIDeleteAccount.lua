require "lua.client.scene.ui.home.uiDeleteAccount.UIDeleteAccountModel"
require "lua.client.scene.ui.home.uiDeleteAccount.UIDeleteAccountView"

--- @class UIDeleteAccount : UIBase
UIDeleteAccount = Class(UIDeleteAccount, UIBase)

--- @return void
function UIDeleteAccount:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDeleteAccount:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDeleteAccountModel()
	self.view = UIDeleteAccountView(self.model, self.ctrl)
end

return UIDeleteAccount
