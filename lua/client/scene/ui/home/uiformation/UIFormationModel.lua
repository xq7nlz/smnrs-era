
--- @class UIFormationModel : UIBaseModel
UIFormationModel = Class(UIFormationModel, UIBaseModel)

--- @return void
function UIFormationModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIFormation, "formation")
	--- @type GameMode
	self.currentMode = nil
	--- @type BattleTeamInfo
	self.defenderTeamInfo = nil
	--- @type TeamFormationInBound
	self.teamFormation = nil

	self.bgDark = false
end

