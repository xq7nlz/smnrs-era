require "lua.client.scene.ui.home.uiCodeVerify.UICodeVerifyModel"
require "lua.client.scene.ui.home.uiCodeVerify.UICodeVerifyView"

--- @class UICodeVerify : UIBase
UICodeVerify = Class(UICodeVerify, UIBase)

--- @return void
function UICodeVerify:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UICodeVerify:OnCreate()
	UIBase.OnCreate(self)
	self.model = UICodeVerifyModel()
	self.view = UICodeVerifyView(self.model, self.ctrl)
end

return UICodeVerify
