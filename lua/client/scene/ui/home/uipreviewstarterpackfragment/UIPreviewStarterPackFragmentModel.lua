
--- @class UIPreviewStarterPackFragmentModel : UIBaseModel
UIPreviewStarterPackFragmentModel = Class(UIPreviewStarterPackFragmentModel, UIBaseModel)

--- @return void
function UIPreviewStarterPackFragmentModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPreviewStarterPackFragment, "ui_preview_starter_pack_fragment")
	self.bgDark = true
end

