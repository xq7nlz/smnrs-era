
--- @class UIHiddenDealModel : UIBaseModel
UIHiddenDealModel = Class(UIHiddenDealModel, UIBaseModel)

--- @return void
function UIHiddenDealModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIHiddenDeal, "hidden_deal")

	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP

	self.bgDark = true
end

