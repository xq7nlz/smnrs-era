require "lua.client.scene.ui.home.uiArenaTeam.UIArenaTeamModel"
require "lua.client.scene.ui.home.uiArenaTeam.UIArenaTeamView"

--- @class UIArenaTeam : UIBase
UIArenaTeam = Class(UIArenaTeam, UIBase)

--- @return void
function UIArenaTeam:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIArenaTeam:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIArenaTeamModel()
	self.view = UIArenaTeamView(self.model)
end

return UIArenaTeam
