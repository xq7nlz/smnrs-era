require "lua.client.scene.ui.home.uiEventSeasonalBossLeaderboard.UIEventSeasonalBossLeaderboardModel"
require "lua.client.scene.ui.home.uiEventSeasonalBossLeaderboard.UIEventSeasonalBossLeaderboardView"

--- @class UIEventSeasonalBossLeaderboard : UIBase
UIEventSeasonalBossLeaderboard = Class(UIEventSeasonalBossLeaderboard, UIBase)

--- @return void
function UIEventSeasonalBossLeaderboard:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIEventSeasonalBossLeaderboard:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventSeasonalBossLeaderboardModel()
	self.view = UIEventSeasonalBossLeaderboardView(self.model)
end

return UIEventSeasonalBossLeaderboard
