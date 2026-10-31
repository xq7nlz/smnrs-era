
--- @class UIPopupPurchaseItemsModel : UIBaseModel
UIPopupPurchaseItemsModel = Class(UIPopupPurchaseItemsModel, UIBaseModel)

--- @return void
function UIPopupPurchaseItemsModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupPurchaseItems, "popup_purchase_items")

	self.bgDark = true
end

