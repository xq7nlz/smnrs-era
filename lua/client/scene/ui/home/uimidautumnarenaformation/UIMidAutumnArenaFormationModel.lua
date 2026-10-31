
--- @class UIMidAutumnArenaFormationModel : UIBaseModel
UIMidAutumnArenaFormationModel = Class(UIMidAutumnArenaFormationModel, UIBaseModel)

--- @return void
function UIMidAutumnArenaFormationModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIMidAutumnArenaFormation, "mid_autumn_arena_formation")
	--- @type GameMode
	self.currentMode = nil
	--- @type BattleTeamInfo
	self.defenderTeamInfo = nil
	--- @type BattleTeamInfo
	self.attackerTeamInfo = nil
	--- @type TeamFormationInBound
	self.teamFormation = nil

	self.bgDark = false
end

