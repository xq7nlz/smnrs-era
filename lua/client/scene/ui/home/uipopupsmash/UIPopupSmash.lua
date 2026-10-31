require "lua.client.scene.ui.home.uiPopupSmash.UIPopupSmashModel"
require "lua.client.scene.ui.home.uiPopupSmash.UIPopupSmashView"

--- @class UIPopupSmash : UIBase
UIPopupSmash = Class(UIPopupSmash, UIBase)

--- @return void
function UIPopupSmash:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIPopupSmash:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIPopupSmashModel()
	self.view = UIPopupSmashView(self.model, self.ctrl)
end

return UIPopupSmash
