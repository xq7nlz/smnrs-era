require "lua.client.scene.ui.home.uiArenaTeamLog.UIArenaTeamLogModel"
require "lua.client.scene.ui.home.uiArenaTeamLog.UIArenaTeamLogView"

--- @class UIArenaTeamLog : UIBase
UIArenaTeamLog = Class(UIArenaTeamLog, UIBase)

--- @return void
function UIArenaTeamLog:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIArenaTeamLog:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIArenaTeamLogModel()
	self.view = UIArenaTeamLogView(self.model)
end

return UIArenaTeamLog
