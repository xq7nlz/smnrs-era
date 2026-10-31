
--- @class UIFormationArenaTeamModel : UIBaseModel
UIFormationArenaTeamModel = Class(UIFormationArenaTeamModel, UIBaseModel)

--- @return void
function UIFormationArenaTeamModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIFormationArenaTeam, "formation_arena_team")

	--- @type BattleTeamInfo
	self.defenderTeamInfo = nil
	--- @type TeamFormationInBound
	self.teamFormation = nil
	--- @type List
	self.listTeamFormation = nil

	self.bgDark = false
end

