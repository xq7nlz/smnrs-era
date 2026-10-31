
--- @class UIRestoreAccountModel : UIBaseModel
UIRestoreAccountModel = Class(UIRestoreAccountModel, UIBaseModel)

--- @return void
function UIRestoreAccountModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIRestoreAccount, "restore_account")

	self.bgDark = true
end

