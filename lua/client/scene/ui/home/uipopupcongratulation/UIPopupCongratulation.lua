require "lua.client.scene.ui.home.uiPopupCongratulation.UIPopupCongratulationModel"
require "lua.client.scene.ui.home.uiPopupCongratulation.UIPopupCongratulationView"

--- @class UIPopupCongratulation
UIPopupCongratulation = Class(UIPopupCongratulation, UIBase)

--- @return void
function UIPopupCongratulation:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupCongratulation:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupCongratulationModel()
	self.view = UIPopupCongratulationView(self.model, self.ctrl)
end

return UIPopupCongratulation
