require "lua.client.scene.ui.home.uiFormationRaid.UIFormationRaidModel"
require "lua.client.scene.ui.home.uiFormationRaid.UIFormationRaidView"

--- @class UIFormationRaid : UIBase
UIFormationRaid = Class(UIFormationRaid, UIBase)

--- @return void
function UIFormationRaid:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFormationRaid:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFormationRaidModel()
	self.view = UIFormationRaidView(self.model)
end

return UIFormationRaid
