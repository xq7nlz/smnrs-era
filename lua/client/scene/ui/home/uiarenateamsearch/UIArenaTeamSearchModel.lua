
--- @class UIArenaTeamSearchModel : UIBaseModel
UIArenaTeamSearchModel = Class(UIArenaTeamSearchModel, UIBaseModel)

--- @return void
function UIArenaTeamSearchModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIArenaTeamSearch, "arena_team_search")
	self.bgDark = true
end

