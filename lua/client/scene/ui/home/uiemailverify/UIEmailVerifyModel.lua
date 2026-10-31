
--- @class UIEmailVerifyModel : UIBaseModel
UIEmailVerifyModel = Class(UIEmailVerifyModel, UIBaseModel)

--- @return void
function UIEmailVerifyModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEmailVerify, "email_verify")

	self.bgDark = true
end

