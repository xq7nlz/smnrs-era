
--- @class UIConfirmClaimRewardBattlePassModel : UIBaseModel
UIConfirmClaimRewardBattlePassModel = Class(UIConfirmClaimRewardBattlePassModel, UIBaseModel)

--- @return void
function UIConfirmClaimRewardBattlePassModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIConfirmClaimRewardBattlePass, "confirm_claim_reward_battle_pass")
	self.bgDark = true
end

