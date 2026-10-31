require "lua.client.scene.ui.home.uiGuildWarSetup.UIGuildWarSetupModel"
require "lua.client.scene.ui.home.uiGuildWarSetup.UIGuildWarSetupView"

--- @class UIGuildWarSetup : UIBase
UIGuildWarSetup = Class(UIGuildWarSetup, UIBase)

--- @return void
function UIGuildWarSetup:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildWarSetup:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildWarSetupModel()
	self.view = UIGuildWarSetupView(self.model)
end

return UIGuildWarSetup
