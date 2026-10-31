
--- @class UIPreviewHeroInfoModel : UIBaseModel
UIPreviewHeroInfoModel = Class(UIPreviewHeroInfoModel, UIBaseModel)

--- @return void
function UIPreviewHeroInfoModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPreviewHeroInfo, "ui_preview_hero_info")

	self.bgDark = true
end

