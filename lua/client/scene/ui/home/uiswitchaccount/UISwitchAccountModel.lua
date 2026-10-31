
--- @class UISwitchAccountModel : UIBaseModel
UISwitchAccountModel = Class(UISwitchAccountModel, UIBaseModel)

--- @return void
function UISwitchAccountModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UISwitchAccount, "switch_account")

	self.bgDark = true
end

