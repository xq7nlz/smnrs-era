require "lua.client.scene.ui.home.uiRateFeedback.UIRateFeedbackModel"
require "lua.client.scene.ui.home.uiRateFeedback.UIRateFeedbackView"

--- @class UIRateFeedback : UIBase
UIRateFeedback = Class(UIRateFeedback, UIBase)

--- @return void
function UIRateFeedback:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIRateFeedback:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIRateFeedbackModel()
	self.view = UIRateFeedbackView(self.model)
end

return UIRateFeedback
