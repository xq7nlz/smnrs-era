
--- @class UIPopupConfirmDownloadAssetBundleModel : UIBaseModel
UIPopupConfirmDownloadAssetBundleModel = Class(UIPopupConfirmDownloadAssetBundleModel, UIBaseModel)

--- @return void
function UIPopupConfirmDownloadAssetBundleModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupConfirmDownloadAssetBundle, "popup_confirm_download_asset_bundle")
end

