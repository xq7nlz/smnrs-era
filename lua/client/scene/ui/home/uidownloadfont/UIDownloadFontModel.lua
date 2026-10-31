
--- @class UIDownloadFontModel : UIBaseModel
UIDownloadFontModel = Class(UIDownloadFontModel, UIBaseModel)

--- @return void
function UIDownloadFontModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDownloadFont, "popup_download_asset_bundle")

	self.bgDark = true
end

