
--- @class UIBoostFirstPurchaseModel : UIBaseModel
UIBoostFirstPurchaseModel = Class(UIBoostFirstPurchaseModel, UIBaseModel)

--- @return void
function UIBoostFirstPurchaseModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIBoostFirstPurchase, "ui_boost_first_purchase")
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP
	self.bgDark = true
	---@type GroupProductConfig
	self.activeGroup = nil
end

---@return GroupProductConfig
function UIBoostFirstPurchaseModel:GetListBundle()
	self.activeGroup = IapDataInBound.GetBoostFirstPurchaseGroup()
	return self.activeGroup
end

