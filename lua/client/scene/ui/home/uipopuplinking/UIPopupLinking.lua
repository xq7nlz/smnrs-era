require "lua.client.scene.ui.home.uiPopupLinking.UIPopupLinkingModel"
require "lua.client.scene.ui.home.uiPopupLinking.UIPopupLinkingView"

--- @class UIPopupLinking : UIBase
UIPopupLinking = Class(UIPopupLinking, UIBase)

--- @return void
function UIPopupLinking:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupLinking:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupLinkingModel()
	self.view = UIPopupLinkingView(self.model, self.ctrl)
end

return UIPopupLinking
