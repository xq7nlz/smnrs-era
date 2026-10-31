
--- @class UIItemPreviewModel : UIBaseModel
UIItemPreviewModel = Class(UIItemPreviewModel, UIBaseModel)

--- @return void
function UIItemPreviewModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIItemPreview, "item_preview")
	self.itemId1 = nil
	self.itemId2 = nil

	self.bgDark = true
end

