require "lua.client.scene.ui.home.uiGuildMain.UIGuildMainModel"
require "lua.client.scene.ui.home.uiGuildMain.UIGuildMainView"

--- @class UIGuildMain : UIBase
UIGuildMain = Class(UIGuildMain, UIBase)

--- @return void
function UIGuildMain:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildMain:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildMainModel()
	self.view = UIGuildMainView(self.model, self.ctrl)
end

return UIGuildMain
