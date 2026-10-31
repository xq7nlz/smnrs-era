require "lua.client.scene.ui.home.uiGuildApply.UIGuildApplyModel"
require "lua.client.scene.ui.home.uiGuildApply.UIGuildApplyView"

--- @class UIGuildApply : UIBase
UIGuildApply = Class(UIGuildApply, UIBase)

--- @return void
function UIGuildApply:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildApply:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildApplyModel()
	self.view = UIGuildApplyView(self.model, self.ctrl)
end

return UIGuildApply
