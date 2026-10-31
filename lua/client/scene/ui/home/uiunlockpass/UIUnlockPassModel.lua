
--- @class UIUnlockPassModel : UIBaseModel
UIUnlockPassModel = Class(UIUnlockPassModel, UIBaseModel)

--- @return void
function UIUnlockPassModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIUnlockPass, "popup_unlock_pass")
	self.bgDark = true
end

