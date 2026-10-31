require "lua.client.scene.ui.home.uiPopupEnhance.UIPopupEnhanceModel"
require "lua.client.scene.ui.home.uiPopupEnhance.UIPopupEnhanceView"

--- @class UIPopupEnhance
UIPopupEnhance = Class(UIPopupEnhance, UIBase)

--- @return void
function UIPopupEnhance:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupEnhance:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupEnhanceModel()
	 --self.ctrl = UIPopupEnhanceCtrl(self.model)
	self.view = UIPopupEnhanceView(self.model, self.ctrl)
end

return UIPopupEnhance
