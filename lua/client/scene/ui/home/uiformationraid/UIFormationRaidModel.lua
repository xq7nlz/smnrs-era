
--- @class UIFormationRaidModel : UIBaseModel
UIFormationRaidModel = Class(UIFormationRaidModel, UIBaseModel)

--- @return void
function UIFormationRaidModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIFormationRaid, "formation_raid")
	--- @type GameMode
	self.currentMode = nil
	--- @type BattleTeamInfo
	self.defenderTeamInfo = nil
	--- @type TeamFormationInBound
	self.teamFormation = nil
	--- @type DefenseFormationConfig
	self.defenseFormationConfig = nil
end

