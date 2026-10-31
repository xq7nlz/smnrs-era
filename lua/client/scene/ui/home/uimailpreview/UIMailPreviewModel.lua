
--- @class UIMailPreviewModel : UIBaseModel
UIMailPreviewModel = Class(UIMailPreviewModel, UIBaseModel)

--- @return void
function UIMailPreviewModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIMailPreview, "popup_mail_preview")

	self.bgDark = true
end

