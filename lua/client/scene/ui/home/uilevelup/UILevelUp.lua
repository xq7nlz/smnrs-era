require "lua.client.scene.ui.home.uiLevelUp.UILevelUpModel"
require "lua.client.scene.ui.home.uiLevelUp.UILevelUpView"

--- @class UILevelUp : UIBase
UILevelUp = Class(UILevelUp, UIBase)

--- @return void
function UILevelUp:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UILevelUp:OnCreate()
	UIBase.OnCreate(self)
	self.model = UILevelUpModel()
	self.view = UILevelUpView(self.model, self.ctrl)
end

return UILevelUp
