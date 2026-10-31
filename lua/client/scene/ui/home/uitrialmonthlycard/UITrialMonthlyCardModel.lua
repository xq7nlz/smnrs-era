
--- @class UITrialMonthlyCardModel : UIBaseModel
UITrialMonthlyCardModel = Class(UITrialMonthlyCardModel, UIBaseModel)

--- @return void
function UITrialMonthlyCardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UITrialMonthlyCard, "monthly_card")

	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP

	self.bgDark = true
end

