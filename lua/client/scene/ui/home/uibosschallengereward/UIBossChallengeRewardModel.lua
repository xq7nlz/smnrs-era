
--- @class UIBossChallengeRewardModel : UIBaseModel
UIBossChallengeRewardModel = Class(UIBossChallengeRewardModel, UIBaseModel)

--- @return void
function UIBossChallengeRewardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIBossChallengeReward, "boss_challenge_rank_reward")
	self.bgDark = true
end

