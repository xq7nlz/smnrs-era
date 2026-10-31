require "lua.client.scene.ui.home.uiPopupNotificationResource.UIPopupNotificationResourceModel"
require "lua.client.scene.ui.home.uiPopupNotificationResource.UIPopupNotificationResourceView"

--- @class UIPopupNotificationResource : UIBase
UIPopupNotificationResource = Class(UIPopupNotificationResource, UIBase)

--- @return void
function UIPopupNotificationResource:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupNotificationResource:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupNotificationResourceModel()
	self.view = UIPopupNotificationResourceView(self.model, self.ctrl)
end

return UIPopupNotificationResource
