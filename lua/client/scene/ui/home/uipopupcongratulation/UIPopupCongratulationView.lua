
--- @class UIPopupCongratulationView : UIBaseView
UIPopupCongratulationView = Class(UIPopupCongratulationView, UIBaseView)

--- @return void
--- @param model UIPopupCongratulationModel
--- @param ctrl UIPopupCongratulationCtrl
function UIPopupCongratulationView:Ctor(model, ctrl)
	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIPopupCongratulationModel
	self.model = self.model
	--- @type UIPopupCongratulationCtrl
	self.ctrl = self.ctrl
end

