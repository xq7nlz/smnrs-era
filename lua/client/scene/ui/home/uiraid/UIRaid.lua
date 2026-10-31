require "lua.client.scene.ui.home.uiRaid.UIRaidModel"
require "lua.client.scene.ui.home.uiRaid.UIRaidView"

--- @class UIRaid : UIBase
UIRaid = Class(UIRaid, UIBase)

--- @return void
function UIRaid:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIRaid:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIRaidModel()
	self.view = UIRaidView(self.model, self.ctrl)
end

return UIRaid
