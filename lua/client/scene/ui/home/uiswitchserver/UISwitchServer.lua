require "lua.client.scene.ui.home.uiSwitchServer.UISwitchServerModel"
require "lua.client.scene.ui.home.uiSwitchServer.UISwitchServerView"

--- @class UISwitchServer : UIBase
UISwitchServer = Class(UISwitchServer, UIBase)

--- @return void
function UISwitchServer:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UISwitchServer:OnCreate()
	UIBase.OnCreate(self)
	self.model = UISwitchServerModel()
	self.view = UISwitchServerView(self.model, self.ctrl)
end

return UISwitchServer
