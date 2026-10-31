--- @class UIEventSeasonalBossLeaderboardModel : UIBaseModel
UIEventSeasonalBossLeaderboardModel = Class(UIEventSeasonalBossLeaderboardModel, UIBaseModel)

--- @return void
function UIEventSeasonalBossLeaderboardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventSeasonalBossLeaderboard, "kazetsu_boss_leader_board")
	self.bgDark = true
	--- @type List
	self.listRanking = nil
end

