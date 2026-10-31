
--- @class UIPopupNotificationDownloadAssetBundleModel : UIBaseModel
UIPopupNotificationDownloadAssetBundleModel = Class(UIPopupNotificationDownloadAssetBundleModel, UIBaseModel)

--- @return void
function UIPopupNotificationDownloadAssetBundleModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupNotificationDownloadAssetBundle, "popup_notification_download_asset_bundle")
end

