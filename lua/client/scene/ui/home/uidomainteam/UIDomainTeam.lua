require "lua.client.scene.ui.home.uiDomainTeam.UIDomainTeamModel"
require "lua.client.scene.ui.home.uiDomainTeam.UIDomainTeamView"

--- @class UIDomainTeam : UIBase
UIDomainTeam = Class(UIDomainTeam, UIBase)

--- @return void
function UIDomainTeam:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDomainTeam:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDomainTeamModel()
	self.view = UIDomainTeamView(self.model)
end

return UIDomainTeam
