
--- @class UIDeleteAccountModel : UIBaseModel
UIDeleteAccountModel = Class(UIDeleteAccountModel, UIBaseModel)

--- @return void
function UIDeleteAccountModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIDeleteAccount, "popup_delete_account")
	self.bgDark = true
end

