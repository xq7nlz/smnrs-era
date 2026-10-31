
--- @class UIPreviewStarterPackModel : UIBaseModel
UIPreviewStarterPackModel = Class(UIPreviewStarterPackModel, UIBaseModel)

--- @return void
function UIPreviewStarterPackModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPreviewStarterPack, "ui_preview_starter_pack")
	self.bgDark = true
end

