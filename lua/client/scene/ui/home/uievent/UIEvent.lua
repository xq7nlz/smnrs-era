require "lua.client.scene.ui.home.uiEvent.UIEventModel"
require "lua.client.scene.ui.home.uiEvent.UIEventView"

--- @class UIEvent : UIBase
UIEvent = Class(UIEvent, UIBase)

--- @return void
function UIEvent:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEvent:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventModel()
	self.view = UIEventView(self.model)
end

return UIEvent
