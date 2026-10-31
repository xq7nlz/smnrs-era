require "lua.client.scene.ui.home.uiEventKazetsu.eventLayout.KazetsuBoss.uiKazetsuBossLeaderBoard.UIKazetsuBossLeaderboardModel"
require "lua.client.scene.ui.home.uiEventKazetsu.eventLayout.KazetsuBoss.uiKazetsuBossLeaderBoard.UIKazetsuBossLeaderboardView"

--- @class UIKazetsuBossLeaderboard : UIBase
UIKazetsuBossLeaderboard = Class(UIKazetsuBossLeaderboard, UIBase)

--- @return void
function UIKazetsuBossLeaderboard:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIKazetsuBossLeaderboard:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIKazetsuBossLeaderboardModel()
	self.view = UIKazetsuBossLeaderboardView(self.model)
end

return UIKazetsuBossLeaderboard
