
--- @class UIFanpageNavigatorModel : UIBaseModel
UIFanpageNavigatorModel = Class(UIFanpageNavigatorModel, UIBaseModel)

--- @return void
function UIFanpageNavigatorModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIFanpageNavigator, "fanpage_navigator")

	self.bgDark = true
end

