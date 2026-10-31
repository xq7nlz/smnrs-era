require "lua.client.scene.ui.home.uiFastForge.UIFastForgeModel"
require "lua.client.scene.ui.home.uiFastForge.UIFastForgeView"

--- @class UIFastForge : UIBase
UIFastForge = Class(UIFastForge, UIBase)

--- @return void
function UIFastForge:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFastForge:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFastForgeModel()
	self.view = UIFastForgeView(self.model, self.ctrl)
end

return UIFastForge
