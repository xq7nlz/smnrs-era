require "lua.client.scene.ui.home.uiSwitchAccount.UISwitchAccountModel"
require "lua.client.scene.ui.home.uiSwitchAccount.UISwitchAccountView"

--- @class UISwitchAccount : UIBase
UISwitchAccount = Class(UISwitchAccount, UIBase)

--- @return void
function UISwitchAccount:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISwitchAccount:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISwitchAccountModel()
	self.view = UISwitchAccountView(self.model)
end

return UISwitchAccount
