
--- @class UIPopupWaitingModel : UIBaseModel
UIPopupWaitingModel = Class(UIPopupWaitingModel, UIBaseModel)

--- @return void
function UIPopupWaitingModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupWaiting, "popup_waiting")
	self.timeCanClose = 1
	self.timeAutoClose = 20
	self.canClosePopup = false
	self.type = UIPopupType.SPECIAL_POPUP
end

