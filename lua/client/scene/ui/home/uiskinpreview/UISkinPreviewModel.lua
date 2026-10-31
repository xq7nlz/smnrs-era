
--- @class UISkinPreviewModel : UIBaseModel
UISkinPreviewModel = Class(UISkinPreviewModel, UIBaseModel)

--- @return void
function UISkinPreviewModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISkinPreview, "skin_preview")

	self.bgDark = true
end

