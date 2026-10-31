
--- @class UIFirstPurchaseModel : UIBaseModel
UIFirstPurchaseModel = Class(UIFirstPurchaseModel, UIBaseModel)

--- @return void
function UIFirstPurchaseModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIFirstPurchase, "first_purchase_pack")

	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP

	self.bgDark = true
end

