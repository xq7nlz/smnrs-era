require "lua.client.scene.ui.home.uiGuildArea.UIGuildAreaModel"
require "lua.client.scene.ui.home.uiGuildArea.UIGuildAreaView"

--- @class UIGuildArea : UIBase
UIGuildArea = Class(UIGuildArea, UIBase)

--- @return void
function UIGuildArea:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildArea:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildAreaModel()
	self.view = UIGuildAreaView(self.model)
end

return UIGuildArea
