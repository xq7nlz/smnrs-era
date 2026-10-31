
--- @class UICodeVerifyModel : UIBaseModel
UICodeVerifyModel = Class(UICodeVerifyModel, UIBaseModel)

--- @return void
function UICodeVerifyModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UICodeVerify, "code_verify")

	self.bgDark = true
end

