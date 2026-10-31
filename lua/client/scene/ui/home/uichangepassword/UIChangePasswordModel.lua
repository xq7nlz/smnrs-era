
--- @class UIChangePasswordModel : UIBaseModel
UIChangePasswordModel = Class(UIChangePasswordModel, UIBaseModel)

--- @return void
function UIChangePasswordModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIChangePassword, "change_pass")

	self.bgDark = true
end

