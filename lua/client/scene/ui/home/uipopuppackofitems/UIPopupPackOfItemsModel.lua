
--- @class UIPopupPackOfItemsModel : UIBaseModel
UIPopupPackOfItemsModel = Class(UIPopupPackOfItemsModel, UIBaseModel)

--- @return void
function UIPopupPackOfItemsModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupPackOfItems, "popup_pack_of_items")

	self.bgDark = true
end

