require "lua.client.scene.ui.home.uiPopupNotificationReward.UIPopupNotificationRewardModel"
require "lua.client.scene.ui.home.uiPopupNotificationReward.UIPopupNotificationRewardView"

--- @class UIPopupNotificationReward : UIBase
UIPopupNotificationReward = Class(UIPopupNotificationReward, UIBase)

--- @return void
function UIPopupNotificationReward:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupNotificationReward:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupNotificationRewardModel()
	self.view = UIPopupNotificationRewardView(self.model)
end

return UIPopupNotificationReward
