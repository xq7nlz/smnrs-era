require "lua.client.scene.ui.home.uiGuildWarPhase3Main.UIGuildWarPhase3MainModel"
require "lua.client.scene.ui.home.uiGuildWarPhase3Main.UIGuildWarPhase3MainView"

--- @class UIGuildWarPhase3Main : UIBase
UIGuildWarPhase3Main = Class(UIGuildWarPhase3Main, UIBase)

--- @return void
function UIGuildWarPhase3Main:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildWarPhase3Main:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildWarPhase3MainModel()
	self.view = UIGuildWarPhase3MainView(self.model)
end

return UIGuildWarPhase3Main
