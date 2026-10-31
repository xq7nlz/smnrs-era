
--- @class UIMailModel : UIBaseModel
UIMailModel = Class(UIMailModel, UIBaseModel)

--- @return void
function UIMailModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIMail, "popup_mail")
	--- @type UIPopupType
	self.type = UIPopupType.BLUR_POPUP

	self.bgDark = false
end

