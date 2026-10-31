require "lua.client.scene.ui.home.uiEventFindeBoss.uiFindeBossLeaderBoard.UIFindeBossLeaderboardModel"
require "lua.client.scene.ui.home.uiEventFindeBoss.uiFindeBossLeaderBoard.UIFindeBossLeaderboardView"

--- @class UIFindeBossLeaderboard : UIBase
UIFindeBossLeaderboard = Class(UIFindeBossLeaderboard, UIBase)

--- @return void
function UIFindeBossLeaderboard:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIFindeBossLeaderboard:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIFindeBossLeaderboardModel()
	self.view = UIFindeBossLeaderboardView(self.model)
end

return UIFindeBossLeaderboard
