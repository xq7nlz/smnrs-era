
--- @class UIArenaTeamOpponentInfoModel : UIBaseModel
UIArenaTeamOpponentInfoModel = Class(UIArenaTeamOpponentInfoModel, UIBaseModel)

--- @return void
function UIArenaTeamOpponentInfoModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIArenaTeamOpponentInfo, "arena_team_preview")
	self.bgDark = true
end

