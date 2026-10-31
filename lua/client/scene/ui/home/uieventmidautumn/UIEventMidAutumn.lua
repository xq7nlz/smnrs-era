require "lua.client.scene.ui.home.uiEventMidAutumn.UIEventMidAutumnModel"
require "lua.client.scene.ui.home.uiEventMidAutumn.UIEventMidAutumnView"

--- @class UIEventMidAutumn : UIBase
UIEventMidAutumn = Class(UIEventMidAutumn, UIBase)

--- @return void
function UIEventMidAutumn:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventMidAutumn:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventMidAutumnModel()
	self.view = UIEventMidAutumnView(self.model)
end

return UIEventMidAutumn
