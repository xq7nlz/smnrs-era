
--- @class UIDailyRewardModel : UIBaseModel
UIDailyRewardModel = Class(UIDailyRewardModel, UIBaseModel)

--- @return void
function UIDailyRewardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDailyReward, "daily_reward")
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP

	self.bgDark = false
end

