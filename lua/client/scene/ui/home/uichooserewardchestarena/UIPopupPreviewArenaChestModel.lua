
--- @class UIPopupPreviewArenaChestModel : UIBaseModel
UIPopupPreviewArenaChestModel = Class(UIPopupPreviewArenaChestModel, UIBaseModel)

--- @return void
function UIPopupPreviewArenaChestModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupArenaChestPreview, "popup_arena_chest_preview")

	self.bgDark = true
end

