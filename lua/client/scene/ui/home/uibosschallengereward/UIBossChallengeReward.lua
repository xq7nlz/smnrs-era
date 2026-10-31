require "lua.client.scene.ui.home.uiBossChallengeReward.UIBossChallengeRewardModel"
require "lua.client.scene.ui.home.uiBossChallengeReward.UIBossChallengeRewardView"

--- @class UIBossChallengeReward : UIBase
UIBossChallengeReward = Class(UIBossChallengeReward, UIBase)

--- @return void
function UIBossChallengeReward:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIBossChallengeReward:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIBossChallengeRewardModel()
	self.view = UIBossChallengeRewardView(self.model)
end

return UIBossChallengeReward
