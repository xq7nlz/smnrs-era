require "lua.client.scene.ui.home.uiEventLunarPath.UIEventLunarPathModel"
require "lua.client.scene.ui.home.uiEventLunarPath.UIEventLunarPathView"

--- @class UIEventLunarPath : UIBase
UIEventLunarPath = Class(UIEventLunarPath, UIBase)

--- @return void
function UIEventLunarPath:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventLunarPath:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventLunarPathModel()
	self.view = UIEventLunarPathView(self.model)
end

return UIEventLunarPath
