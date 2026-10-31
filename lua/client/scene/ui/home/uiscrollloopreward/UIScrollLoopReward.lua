require "lua.client.scene.ui.home.uiScrollLoopReward.UIScrollLoopRewardModel"
require "lua.client.scene.ui.home.uiScrollLoopReward.UIScrollLoopRewardView"

--- @class UIScrollLoopReward : UIBase
UIScrollLoopReward = Class(UIScrollLoopReward, UIBase)

--- @return void
function UIScrollLoopReward:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIScrollLoopReward:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIScrollLoopRewardModel()
	self.view = UIScrollLoopRewardView(self.model, self.ctrl)
end

return UIScrollLoopReward
