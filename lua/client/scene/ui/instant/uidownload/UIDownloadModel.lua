
--- @class UIDownloadModel : UIBaseModel
UIDownloadModel = Class(UIDownloadModel, UIBaseModel)

--- @return void
function UIDownloadModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDownload, "popup_download")
end

