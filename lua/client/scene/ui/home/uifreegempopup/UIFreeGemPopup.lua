require "lua.client.scene.ui.home.uiFreeGemPopup.UIFreeGemPopupModel"
require "lua.client.scene.ui.home.uiFreeGemPopup.UIFreeGemPopupView"

--- @class UIFreeGemPopup : UIBase
UIFreeGemPopup = Class(UIFreeGemPopup, UIBase)

--- @return void
function UIFreeGemPopup:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFreeGemPopup:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFreeGemPopupModel()
	self.view = UIFreeGemPopupView(self.model)
end

return UIFreeGemPopup
