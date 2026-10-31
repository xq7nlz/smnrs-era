require "lua.client.scene.ui.home.uiGuildRecruit.UIGuildRecruitModel"
require "lua.client.scene.ui.home.uiGuildRecruit.UIGuildRecruitView"

--- @class UIGuildRecruit : UIBase
UIGuildRecruit = Class(UIGuildRecruit, UIBase)

--- @return void
function UIGuildRecruit:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildRecruit:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildRecruitModel()
	self.view = UIGuildRecruitView(self.model, self.ctrl)
end

return UIGuildRecruit
