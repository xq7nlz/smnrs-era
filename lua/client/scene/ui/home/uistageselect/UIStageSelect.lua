require "lua.client.scene.ui.home.uiStageSelect.UIStageSelectModel"
require "lua.client.scene.ui.home.uiStageSelect.UIStageSelectView"

--- @class UIStageSelect
UIStageSelect = Class(UIStageSelect, UIBase)

--- @return void
function UIStageSelect:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIStageSelect:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIStageSelectModel()
	self.view = UIStageSelectView(self.model, self.ctrl)
end

return UIStageSelect
