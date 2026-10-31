require "lua.client.scene.ui.home.uiGeneralSetting.UIGeneralSettingModel"
require "lua.client.scene.ui.home.uiGeneralSetting.UIGeneralSettingView"

--- @class UIGeneralSetting : UIBase
UIGeneralSetting = Class(UIGeneralSetting, UIBase)

--- @return void
function UIGeneralSetting:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGeneralSetting:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGeneralSettingModel()
	self.view = UIGeneralSettingView(self.model, self.ctrl)
end

return UIGeneralSetting
