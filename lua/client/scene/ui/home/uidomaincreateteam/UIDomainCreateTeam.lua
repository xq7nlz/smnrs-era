require "lua.client.scene.ui.home.uiDomainCreateTeam.UIDomainCreateTeamModel"
require "lua.client.scene.ui.home.uiDomainCreateTeam.UIDomainCreateTeamView"

--- @class UIDomainCreateTeam : UIBase
UIDomainCreateTeam = Class(UIDomainCreateTeam, UIBase)

--- @return void
function UIDomainCreateTeam:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDomainCreateTeam:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDomainCreateTeamModel()
	self.view = UIDomainCreateTeamView(self.model)
end

return UIDomainCreateTeam
