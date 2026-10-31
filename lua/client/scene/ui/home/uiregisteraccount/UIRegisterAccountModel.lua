
--- @class UIRegisterAccountModel : UIBaseModel
UIRegisterAccountModel = Class(UIRegisterAccountModel, UIBaseModel)

--- @return void
function UIRegisterAccountModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIRegisterAccount, "register_account")

	self.bgDark = true
end

