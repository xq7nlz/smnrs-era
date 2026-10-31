require "lua.client.scene.ui.home.uiVip.UIVipModel"
require "lua.client.scene.ui.home.uiVip.UIVipView"

--- @class UIVip : UIBase
UIVip = Class(UIVip, UIBase)

--- @return void
function UIVip:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIVip:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIVipModel()
	self.view = UIVipView(self.model, self.ctrl)
end

return UIVip
