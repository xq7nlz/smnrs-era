--- @class UIPreviewLionDanceFragmentModel : UIBaseModel
UIPreviewLionDanceFragmentModel = Class(UIPreviewLionDanceFragmentModel, UIBaseModel)

--- @return void
function UIPreviewLionDanceFragmentModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPreviewLionDanceFragment, "ui_preview_lion_dance_fragment")
	self.bgDark = true
end

