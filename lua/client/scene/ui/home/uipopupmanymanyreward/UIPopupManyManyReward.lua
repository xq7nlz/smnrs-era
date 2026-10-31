require "lua.client.scene.ui.home.uiPopupManyManyReward.UIPopupManyManyRewardModel"
require "lua.client.scene.ui.home.uiPopupManyManyReward.UIPopupManyManyRewardView"

--- @class UIPopupManyManyReward : UIBase
UIPopupManyManyReward = Class(UIPopupManyManyReward, UIBase)

--- @return void
function UIPopupManyManyReward:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupManyManyReward:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupManyManyRewardModel()
	self.view = UIPopupManyManyRewardView(self.model)
end

return UIPopupManyManyReward
