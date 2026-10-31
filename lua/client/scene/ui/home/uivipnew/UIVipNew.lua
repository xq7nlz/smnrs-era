require "lua.client.scene.ui.home.uiVipNew.UIVipNewModel"
require "lua.client.scene.ui.home.uiVipNew.UIVipNewView"

--- @class \UIVipNew : UIBase
UIVipNew = Class(UIVipNew, UIBase)

--- @return void
function UIVipNew:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIVipNew:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIVipNewModel()
	self.view = UIVipNewView(self.model, self.ctrl)
end

return UIVipNew
