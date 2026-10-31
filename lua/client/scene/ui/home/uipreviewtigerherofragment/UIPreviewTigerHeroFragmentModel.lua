--- @class UIPreviewTigerHeroFragmentModel : UIBaseModel
UIPreviewTigerHeroFragmentModel = Class(UIPreviewTigerHeroFragmentModel, UIBaseModel)

--- @return void
function UIPreviewTigerHeroFragmentModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPreviewTigerHeroFragment, "ui_preview_tiger_path_fragment")
	self.bgDark = true
end

