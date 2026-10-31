require "lua.client.scene.ui.home.uiGameStats.UIGameStatsModel"
require "lua.client.scene.ui.home.uiGameStats.UIGameStatsView"
---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiGameStats.UIGameStatsConfig"

--- @class UIGameStats : UIBase
UIGameStats = Class(UIGameStats, UIBase)

--- @return void
function UIGameStats:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIGameStats:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIGameStatsModel()
	self.view = UIGameStatsView(self.model, self.ctrl)
end

return UIGameStats
