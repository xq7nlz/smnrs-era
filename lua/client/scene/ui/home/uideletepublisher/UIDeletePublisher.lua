require "lua.client.scene.ui.home.uiDeletePublisher.UIDeletePublisherModel"
require "lua.client.scene.ui.home.uiDeletePublisher.UIDeletePublisherView"

--- @class UIDeletePublisher : UIBase
UIDeletePublisher = Class(UIDeletePublisher, UIBase)

--- @return void
function UIDeletePublisher:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIDeletePublisher:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIDeletePublisherModel()
	self.view = UIDeletePublisherView(self.model, self.ctrl)
end

return UIDeletePublisher
