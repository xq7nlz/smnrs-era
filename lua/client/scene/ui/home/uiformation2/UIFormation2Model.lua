
--- @class UIFormation2Model : UIBaseModel
UIFormation2Model = Class(UIFormation2Model, UIBaseModel)

--- @return void
function UIFormation2Model:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIFormation2, "formation2")

	--- @type GameMode
	self.currentMode = nil
	--- @type BattleTeamInfo
	self.defenderTeamInfo = nil
	--- @type TeamFormationInBound
	self.teamFormation = nil

	self.bgDark = false
end

