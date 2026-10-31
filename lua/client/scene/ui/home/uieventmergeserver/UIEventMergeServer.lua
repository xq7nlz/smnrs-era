require "lua.client.scene.ui.home.uiEventMergeServer.UIEventMergeServerModel"
require "lua.client.scene.ui.home.uiEventMergeServer.UIEventMergeServerView"

--- @class UIEventMergeServer : UIBase
UIEventMergeServer = Class(UIEventMergeServer, UIBase)

--- @return void
function UIEventMergeServer:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventMergeServer:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventMergeServerModel()
	self.view = UIEventMergeServerView(self.model)
end

return UIEventMergeServer
