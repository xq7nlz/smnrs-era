
--- @class UIPopupNotificationRewardModel : UIBaseModel
UIPopupNotificationRewardModel = Class(UIPopupNotificationRewardModel, UIBaseModel)

--- @return void
function UIPopupNotificationRewardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupNotificationReward, "popup_notification_reward")
	--- @type List --<ItemIconData>
	self.resourceList = List()
	self.bgDark = true
end

