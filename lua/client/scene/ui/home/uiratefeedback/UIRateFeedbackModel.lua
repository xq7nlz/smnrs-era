
--- @class UIRateFeedbackModel : UIBaseModel
UIRateFeedbackModel = Class(UIRateFeedbackModel, UIBaseModel)

--- @return void
function UIRateFeedbackModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIRateFeedback, "rate_feedback")

	self.bgDark = true
end

