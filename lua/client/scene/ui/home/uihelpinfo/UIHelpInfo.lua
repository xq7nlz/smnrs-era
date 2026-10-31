require "lua.client.scene.ui.home.uiHelpInfo.UIHelpInfoModel"
require "lua.client.scene.ui.home.uiHelpInfo.UIHelpInfoView"

--- @class UIHelpInfo : UIBase
UIHelpInfo = Class(UIHelpInfo, UIBase)

--- @return void
function UIHelpInfo:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIHelpInfo:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIHelpInfoModel()
	self.view = UIHelpInfoView(self.model, self.ctrl)
end

return UIHelpInfo
