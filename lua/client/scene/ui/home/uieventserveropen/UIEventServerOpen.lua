require "lua.client.scene.ui.home.uiEventServerOpen.UIEventServerOpenModel"
require "lua.client.scene.ui.home.uiEventServerOpen.UIEventServerOpenView"

--- @class UIEventServerOpen : UIBase
UIEventServerOpen = Class(UIEventServerOpen, UIBase)

--- @return void
function UIEventServerOpen:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventServerOpen:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventServerOpenModel()
	self.view = UIEventServerOpenView(self.model)
end

return UIEventServerOpen
