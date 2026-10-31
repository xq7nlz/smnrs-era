
--- @class UIArenaTeamLogModel : UIBaseModel
UIArenaTeamLogModel = Class(UIArenaTeamLogModel, UIBaseModel)

--- @return void
function UIArenaTeamLogModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIArenaTeamLog, "ui_arena_team_log")
	self.bgDark = true
end

