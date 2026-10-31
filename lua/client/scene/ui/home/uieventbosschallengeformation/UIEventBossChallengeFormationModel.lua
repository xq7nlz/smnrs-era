
--- @class UIEventBossChallengeFormationModel : UIBaseModel
UIEventBossChallengeFormationModel = Class(UIEventBossChallengeFormationModel, UIBaseModel)

--- @return void
function UIEventBossChallengeFormationModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventBossChallengeFormation, "event_boss_challenge_formation")
	--- @type GameMode
	self.currentMode = nil
	--- @type BattleTeamInfo
	self.defenderTeamInfo = nil
	--- @type TeamFormationInBound
	self.teamFormation = nil
end

