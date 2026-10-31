require "lua.client.scene.ui.home.uiPopupSplitReward.UIPopupSplitRewardModel"
require "lua.client.scene.ui.home.uiPopupSplitReward.UIPopupSplitRewardView"

--- @class UIPopupSplitReward : UIBase
UIPopupSplitReward = Class(UIPopupSplitReward, UIBase)

--- @return void
function UIPopupSplitReward:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupSplitReward:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupSplitRewardModel()
	self.view = UIPopupSplitRewardView(self.model)
end

return UIPopupSplitReward
