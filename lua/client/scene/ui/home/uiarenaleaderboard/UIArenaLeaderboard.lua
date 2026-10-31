require "lua.client.scene.ui.home.uiArenaLeaderboard.UIArenaLeaderboardModel"
require "lua.client.scene.ui.home.uiArenaLeaderboard.UIArenaLeaderboardView"

--- @class UIArenaLeaderboard : UIBase
UIArenaLeaderboard = Class(UIArenaLeaderboard, UIBase)

--- @return void
function UIArenaLeaderboard:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIArenaLeaderboard:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIArenaLeaderboardModel()
	self.view = UIArenaLeaderboardView(self.model)
end

return UIArenaLeaderboard
