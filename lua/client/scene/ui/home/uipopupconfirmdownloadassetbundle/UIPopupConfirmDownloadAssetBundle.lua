require "lua.client.scene.ui.home.uiPopupConfirmDownloadAssetBundle.UIPopupConfirmDownloadAssetBundleModel"
require "lua.client.scene.ui.home.uiPopupConfirmDownloadAssetBundle.UIPopupConfirmDownloadAssetBundleView"

--- @class UIPopupConfirmDownloadAssetBundle : UIBase
UIPopupConfirmDownloadAssetBundle = Class(UIPopupConfirmDownloadAssetBundle, UIBase)

--- @return void
function UIPopupConfirmDownloadAssetBundle:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupConfirmDownloadAssetBundle:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupConfirmDownloadAssetBundleModel()
	self.view = UIPopupConfirmDownloadAssetBundleView(self.model)
end

return UIPopupConfirmDownloadAssetBundle
