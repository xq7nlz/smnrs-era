require "lua.client.scene.ui.home.uiEventNewVip.UIEventNewVipModel"
require "lua.client.scene.ui.home.uiEventNewVip.UIEventNewVipView"

--- @class UIEventNewVip : UIBase
UIEventNewVip = Class(UIEventNewVip, UIBase)

--- @return void
function UIEventNewVip:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventNewVip:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventNewVipModel()
	self.view = UIEventNewVipView(self.model)
end

return UIEventNewVip
