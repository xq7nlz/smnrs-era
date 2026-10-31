require "lua.client.scene.ui.home.uiLanguageSetting.UILanguageSettingModel"
require "lua.client.scene.ui.home.uiLanguageSetting.UILanguageSettingView"

--- @class UILanguageSetting : UIBase
UILanguageSetting = Class(UILanguageSetting, UIBase)

--- @return void
function UILanguageSetting:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UILanguageSetting:OnCreate()
	UIBase.OnCreate(self)
	self.model = UILanguageSettingModel()
	self.view = UILanguageSettingView(self.model, self.ctrl)
end

return UILanguageSetting
