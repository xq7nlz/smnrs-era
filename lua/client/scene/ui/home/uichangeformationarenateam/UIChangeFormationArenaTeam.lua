require "lua.client.scene.ui.home.uiChangeFormationArenaTeam.UIChangeFormationArenaTeamModel"
require "lua.client.scene.ui.home.uiChangeFormationArenaTeam.UIChangeFormationArenaTeamView"

--- @class UIChangeFormationArenaTeam : UIBase
UIChangeFormationArenaTeam = Class(UIChangeFormationArenaTeam, UIBase)

--- @return void
function UIChangeFormationArenaTeam:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIChangeFormationArenaTeam:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIChangeFormationArenaTeamModel()
	self.view = UIChangeFormationArenaTeamView(self.model)
end

return UIChangeFormationArenaTeam
