--[[

--- @class UIFirstTimeRewardModel : UIBaseModel
UIFirstTimeRewardModel = Class(UIFirstTimeRewardModel, UIBaseModel)

--- @return void
function UIFirstTimeRewardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIFirstTimeReward, "first_time_reward")

	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP
	self.bgDark = true
end

]]
