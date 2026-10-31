
--- @class UIPopupNotificationResourceModel : UIBaseModel
UIPopupNotificationResourceModel = Class(UIPopupNotificationResourceModel, UIBaseModel)

--- @return void
function UIPopupNotificationResourceModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupNotificationResource, "popup_resource_notification")

	self.bgDark = true
end

