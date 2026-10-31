
--- @class UIHelpInfoModel : UIBaseModel
UIHelpInfoModel = Class(UIHelpInfoModel, UIBaseModel)

--- @return void
function UIHelpInfoModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIHelpInfo, "help_info")

	self.bgDark = true
end

