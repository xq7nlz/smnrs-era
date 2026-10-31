require "lua.client.scene.ui.home.uiDungeonFormation.UIDungeonFormationModel"
require "lua.client.scene.ui.home.uiDungeonFormation.UIDungeonFormationView"

--- @class UIDungeonFormation : UIBase
UIDungeonFormation = Class(UIDungeonFormation, UIBase)

--- @return void
function UIDungeonFormation:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDungeonFormation:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDungeonFormationModel()
	self.view = UIDungeonFormationView(self.model)
end

return UIDungeonFormation
