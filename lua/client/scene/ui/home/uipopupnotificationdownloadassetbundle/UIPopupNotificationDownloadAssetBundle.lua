require "lua.client.scene.ui.home.uiPopupNotificationDownloadAssetBundle.UIPopupNotificationDownloadAssetBundleModel"
require "lua.client.scene.ui.home.uiPopupNotificationDownloadAssetBundle.UIPopupNotificationDownloadAssetBundleView"

--- @class UIPopupNotificationDownloadAssetBundle : UIBase
UIPopupNotificationDownloadAssetBundle = Class(UIPopupNotificationDownloadAssetBundle, UIBase)

--- @return void
function UIPopupNotificationDownloadAssetBundle:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupNotificationDownloadAssetBundle:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupNotificationDownloadAssetBundleModel()
	self.view = UIPopupNotificationDownloadAssetBundleView(self.model)
end

return UIPopupNotificationDownloadAssetBundle
