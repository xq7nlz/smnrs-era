require "lua.client.scene.ui.home.uiUnlockPass.UIUnlockPassModel"
require "lua.client.scene.ui.home.uiUnlockPass.UIUnlockPassView"

--- @class UIUnlockPass : UIBase
UIUnlockPass = Class(UIUnlockPass, UIBase)

--- @return void
function UIUnlockPass:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIUnlockPass:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIUnlockPassModel()
	self.view = UIUnlockPassView(self.model)
end

return UIUnlockPass
