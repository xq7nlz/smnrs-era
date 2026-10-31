
------ @class UIEventLoginModel : UIBaseModel
UIEventLoginModel = Class(UIEventLoginModel, UIBaseModel)

--- @return void
function UIEventLoginModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventLogin, "event_login")

	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP
	self.bgDark = true
end