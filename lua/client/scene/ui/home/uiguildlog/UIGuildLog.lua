require "lua.client.scene.ui.home.uiGuildLog.UIGuildLogModel"
require "lua.client.scene.ui.home.uiGuildLog.UIGuildLogView"

--- @class UIGuildLog : UIBase
UIGuildLog = Class(UIGuildLog, UIBase)

--- @return void
function UIGuildLog:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGuildLog:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGuildLogModel()
	self.view = UIGuildLogView(self.model, self.ctrl)
end

return UIGuildLog
