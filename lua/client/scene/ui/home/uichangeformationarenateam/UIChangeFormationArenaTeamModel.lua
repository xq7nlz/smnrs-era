
--- @class UIChangeFormationArenaTeamModel : UIBaseModel
UIChangeFormationArenaTeamModel = Class(UIChangeFormationArenaTeamModel, UIBaseModel)

--- @return void
function UIChangeFormationArenaTeamModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIChangeFormationArenaTeam, "arena_team_change")

	self.bgDark = true
end

