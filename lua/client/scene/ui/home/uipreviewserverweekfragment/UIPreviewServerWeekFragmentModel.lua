
--- @class UIPreviewServerWeekFragmentModel : UIBaseModel
UIPreviewServerWeekFragmentModel = Class(UIPreviewServerWeekFragmentModel, UIBaseModel)

--- @return void
function UIPreviewServerWeekFragmentModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPreviewServerWeekFragment, "ui_preview_serverweekbundle_fragment")
	self.bgDark = true
end

