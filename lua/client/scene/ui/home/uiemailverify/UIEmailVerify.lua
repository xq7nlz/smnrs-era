require "lua.client.scene.ui.home.uiEmailVerify.UIEmailVerifyModel"
require "lua.client.scene.ui.home.uiEmailVerify.UIEmailVerifyView"

--- @class UIEmailVerify : UIBase
UIEmailVerify = Class(UIEmailVerify, UIBase)

--- @return void
function UIEmailVerify:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEmailVerify:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEmailVerifyModel()
	self.view = UIEmailVerifyView(self.model, self.ctrl)
end

return UIEmailVerify
