require "lua.client.scene.ui.home.uiEventFindeBoss.UIEventFindeBossModel"
require "lua.client.scene.ui.home.uiEventFindeBoss.UIEventFindeBossView"

--- @class UIEventFindeBoss : UIBase
UIEventFindeBoss = Class(UIEventFindeBoss, UIBase)

--- @return void
function UIEventFindeBoss:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventFindeBoss:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventFindeBossModel()
	self.view = UIEventFindeBossView(self.model)
end

return UIEventFindeBoss
