
--- @class UIKazetsuTrialFormationModel : UIBaseModel
UIKazetsuTrialFormationModel = Class(UIKazetsuTrialFormationModel, UIBaseModel)

--- @return void
function UIKazetsuTrialFormationModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIKazetsuTrialFormation, "kazetsu_trial_formation")
	--- @type GameMode
	self.currentMode = nil
	--- @type BattleTeamInfo
	self.defenderTeamInfo = nil
	--- @type TeamFormationInBound
	self.teamFormation = nil

	self.bgDark = false
end

