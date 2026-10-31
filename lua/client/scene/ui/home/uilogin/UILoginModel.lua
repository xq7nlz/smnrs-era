
--- @class UILoginModel : UIBaseModel
UILoginModel = Class(UILoginModel, UIBaseModel)

--- @return void
function UILoginModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UILogin, "login")

	self.bgDark = true
end

