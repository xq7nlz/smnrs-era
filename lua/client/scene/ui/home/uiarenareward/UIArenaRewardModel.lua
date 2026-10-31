
--- @class UIArenaRewardModel : UIBaseModel
UIArenaRewardModel = Class(UIArenaRewardModel, UIBaseModel)

--- @return void
function UIArenaRewardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIArenaReward, "arena_reward")

	self.bgDark = true
end

