
--- @class UIPopupPurchaseLevelModel : UIBaseModel
UIPopupPurchaseLevelModel = Class(UIPopupPurchaseLevelModel, UIBaseModel)

--- @return void
function UIPopupPurchaseLevelModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupPurchaseLevel, "popup_purchase_level")

	--- @type List <ItemIconData>
	self.resourceList = List()

	self.bgDark = true
end

