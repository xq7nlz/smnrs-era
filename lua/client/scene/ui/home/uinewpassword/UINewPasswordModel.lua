
--- @class UINewPasswordModel : UIBaseModel
UINewPasswordModel = Class(UINewPasswordModel, UIBaseModel)

--- @return void
function UINewPasswordModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UINewPassword, "new_password")

	self.bgDark = true
end

