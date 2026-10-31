require "lua.client.scene.ui.home.uiDailyReward.UIDailyRewardModel"
require "lua.client.scene.ui.home.uiDailyReward.UIDailyRewardView"

--- @class UIDailyReward : UIBase
UIDailyReward = Class(UIDailyReward, UIBase)

--- @return void
function UIDailyReward:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDailyReward:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDailyRewardModel()
	self.view = UIDailyRewardView(self.model, self.ctrl)
end

return UIDailyReward
