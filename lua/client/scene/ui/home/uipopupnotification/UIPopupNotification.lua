require "lua.client.scene.ui.home.uiPopupNotification.UIPopupNotificationModel"
require "lua.client.scene.ui.home.uiPopupNotification.UIPopupNotificationView"

--- @class UIPopupNotification : UIBase
UIPopupNotification = Class(UIPopupNotification, UIBase)

--- @return void
function UIPopupNotification:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupNotification:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupNotificationModel()
	self.view = UIPopupNotificationView(self.model, self.ctrl)
end

return UIPopupNotification
