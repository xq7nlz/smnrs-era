
--- @class UIFormationDefenseModel : UIBaseModel
UIFormationDefenseModel = Class(UIFormationDefenseModel, UIBaseModel)

--- @return void
function UIFormationDefenseModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIFormationDefense, "formation_defense")

	--- @type BattleTeamInfo
	self.defenderTeamInfo = nil
	--- @type TeamFormationInBound
	self.teamFormation = nil
	--- @type DefenseFormationConfig
	self.defenseFormationConfig = nil

	self.bgDark = false
end

