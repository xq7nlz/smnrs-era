require "lua.client.scene.ui.home.uiEventBirthdayBossLeaderBoard.UIEventBirthdayBossLeaderboardModel"
require "lua.client.scene.ui.home.uiEventBirthdayBossLeaderBoard.UIEventBirthdayBossLeaderboardView"

--- @class UIBirthdayBossLeaderboard : UIBase
UIBirthdayBossLeaderboard = Class(UIBirthdayBossLeaderboard, UIBase)

--- @return void
function UIBirthdayBossLeaderboard:Ctor()
	UIBase.Ctor(self)
end

--- @return void
function UIBirthdayBossLeaderboard:OnCreate()
	UIBase.OnCreate(self)
	self.model = UIEventBirthdayBossLeaderboardModel()
	self.view = UIEventBirthdayBossLeaderboardView(self.model)
end

return UIBirthdayBossLeaderboard
