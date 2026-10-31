
--- @class UIPopupNotificationModel : UIBaseModel
UIPopupNotificationModel = Class(UIPopupNotificationModel, UIBaseModel)

--- @return void
function UIPopupNotificationModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupNotification, "popup_notification")

	self.bgDark = true
end

