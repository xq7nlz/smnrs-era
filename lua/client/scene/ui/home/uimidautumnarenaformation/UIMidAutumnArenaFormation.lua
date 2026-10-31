require "lua.client.scene.ui.home.uiMidAutumnArenaFormation.UIMidAutumnArenaFormationModel"
require "lua.client.scene.ui.home.uiMidAutumnArenaFormation.UIMidAutumnArenaFormationView"

--- @class UIMidAutumnArenaFormation : UIBase
UIMidAutumnArenaFormation = Class(UIMidAutumnArenaFormation, UIBase)

--- @return void
function UIMidAutumnArenaFormation:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIMidAutumnArenaFormation:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIMidAutumnArenaFormationModel()
	self.view = UIMidAutumnArenaFormationView(self.model)
end

return UIMidAutumnArenaFormation
