
--- @class UIBossChallengeQuickBattleModel : UIBaseModel
UIBossChallengeQuickBattleModel = Class(UIBossChallengeQuickBattleModel, UIBaseModel)

--- @return void
function UIBossChallengeQuickBattleModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIBossChallengeQuickBattle, "popup_boss_challenge_quick_battle")
end

