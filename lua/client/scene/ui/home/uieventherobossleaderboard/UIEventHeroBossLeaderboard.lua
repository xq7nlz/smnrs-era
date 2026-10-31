require "lua.client.scene.ui.home.uiEventHeroBossLeaderboard.UIEventHeroBossLeaderboardModel"
require "lua.client.scene.ui.home.uiEventHeroBossLeaderboard.UIEventHeroBossLeaderboardView"

--- @class UIHeroBossLeaderboard : UIBase
UIHeroBossLeaderboard = Class(UIHeroBossLeaderboard, UIBase)

--- @return void
function UIHeroBossLeaderboard:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIHeroBossLeaderboard:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventHeroBossLeaderboardModel()
	self.view = UIEventHeroBossLeaderboardView(self.model)
end

return UIHeroBossLeaderboard
