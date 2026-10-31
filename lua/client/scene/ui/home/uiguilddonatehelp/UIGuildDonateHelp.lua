require "lua.client.scene.ui.home.uiGuildDonateHelp.UIGuildDonateHelpModel"
require "lua.client.scene.ui.home.uiGuildDonateHelp.UIGuildDonateHelpView"

--- @class UIGuildDonateHelp : UIBase
UIGuildDonateHelp = Class(UIGuildDonateHelp, UIBase)

--- @return void
function UIGuildDonateHelp:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildDonateHelp:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildDonateHelpModel()
	self.view = UIGuildDonateHelpView(self.model)
end

return UIGuildDonateHelp
