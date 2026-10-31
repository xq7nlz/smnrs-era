
--- @class UIPopupSelectWheelModel : UIBaseModel
UIPopupSelectWheelModel = Class(UIPopupSelectWheelModel, UIBaseModel)

--- @return void
function UIPopupSelectWheelModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIPopupSelectWheel, "popup_select_wheel")
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP

	self.bgDark = true
end

