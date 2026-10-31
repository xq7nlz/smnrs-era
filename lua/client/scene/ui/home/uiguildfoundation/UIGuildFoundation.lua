require "lua.client.scene.ui.home.uiGuildFoundation.UIGuildFoundationModel"
require "lua.client.scene.ui.home.uiGuildFoundation.UIGuildFoundationView"

--- @class UIGuildFoundation : UIBase
UIGuildFoundation = Class(UIGuildFoundation, UIBase)

--- @return void
function UIGuildFoundation:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildFoundation:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildFoundationModel()
	self.view = UIGuildFoundationView(self.model, self.ctrl)
end

return UIGuildFoundation
