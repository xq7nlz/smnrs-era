--- @class UIEventHeroBossLeaderboardModel : UIBaseModel
UIEventHeroBossLeaderboardModel = Class(UIEventHeroBossLeaderboardModel, UIBaseModel)

--- @return void
function UIEventHeroBossLeaderboardModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventHeroBossLeaderboard, "kazetsu_boss_leader_board")
	self.bgDark = true

	--- @type List
	self.listRanking = nil
end

