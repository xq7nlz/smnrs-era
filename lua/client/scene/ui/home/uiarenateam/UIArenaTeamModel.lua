
--- @class UIArenaTeamModel : UIBaseModel
UIArenaTeamModel = Class(UIArenaTeamModel, UIBaseModel)

--- @return void
function UIArenaTeamModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIArenaTeam, "arena_team")
end

