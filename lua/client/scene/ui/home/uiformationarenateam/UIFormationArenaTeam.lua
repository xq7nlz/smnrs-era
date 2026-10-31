require "lua.client.scene.ui.home.uiFormationArenaTeam.UIFormationArenaTeamModel"
require "lua.client.scene.ui.home.uiFormationArenaTeam.UIFormationArenaTeamView"

--- @class UIFormationArenaTeam : UIBase
UIFormationArenaTeam = Class(UIFormationArenaTeam, UIBase)

--- @return void
function UIFormationArenaTeam:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFormationArenaTeam:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFormationArenaTeamModel()
	self.view = UIFormationArenaTeamView(self.model)
end

return UIFormationArenaTeam
