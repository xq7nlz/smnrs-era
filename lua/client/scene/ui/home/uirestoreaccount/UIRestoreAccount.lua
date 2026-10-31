require "lua.client.scene.ui.home.uiRestoreAccount.UIRestoreAccountModel"
require "lua.client.scene.ui.home.uiRestoreAccount.UIRestoreAccountView"

--- @class UIRestoreAccount : UIBase
UIRestoreAccount = Class(UIRestoreAccount, UIBase)

--- @return void
function UIRestoreAccount:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIRestoreAccount:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIRestoreAccountModel()
	self.view = UIRestoreAccountView(self.model, self.ctrl)
end

return UIRestoreAccount
